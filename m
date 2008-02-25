Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbYBYSmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbYBYSmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYBYSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:41:54 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685AbYBYSlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:41:53 -0500
Date: Mon, 25 Feb 2008 10:40:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]iommu-iotlb-flushing
Message-Id: <20080225104024.c5b5d719.akpm@linux-foundation.org>
In-Reply-To: <20080225162851.GC22018@linux.intel.com>
References: <20080221000623.GA5510@linux.intel.com>
	<20080223000517.232704f3.akpm@linux-foundation.org>
	<20080225162851.GC22018@linux.intel.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 08:28:51 -0800 mark gross <mgross@linux.intel.com> wrote:

> > > +	/*just flush them all*/
> > 
> > I'm surprised that checkpatch didn't grump about the odd commenting style.
> 
> It didn't.  What's odd about the comment style here?

We normally put a space after "/*" and before "*/"
