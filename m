Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbXJVW5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbXJVW5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXJVW5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:57:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbXJVW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:57:06 -0400
Date: Mon, 22 Oct 2007 15:56:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: bharata@linux.vnet.ibm.com, jblunck@suse.de, agruen@suse.de, hch@lst.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] Rename {__}d_path() to {__}print_path() and fix
 comments
Message-Id: <20071022155647.489a634f.akpm@linux-foundation.org>
In-Reply-To: <20071022101443.GB20690@infradead.org>
References: <20071022065352.GA6489@in.ibm.com>
	<20071022070419.GN6489@in.ibm.com>
	<20071022101443.GB20690@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 11:14:43 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Oct 22, 2007 at 12:34:19PM +0530, Bharata B Rao wrote:
> > Changes the name of d_path() and __d_path() to print_path() and __print_path()
> > respectively and fixes the kerneldoc comments for print_path().
> 
> I don't think we want to put in this rename until d_path is changed to
> actually take a struct path * describing the path to be printed.

I didn't merge this one.
