Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXA2TGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXA2TGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXA2TGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:06:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXA2TGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:06:08 -0500
Date: Mon, 29 Jan 2007 14:06:04 -0500
From: Alan Cox <alan@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: cleanup release_mem
Message-ID: <20070129190604.GA20564@devserv.devel.redhat.com>
References: <20070128171244.GA21378@lst.de> <20070129120100.GA4338@devserv.devel.redhat.com> <20070129181235.GA9063@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129181235.GA9063@lst.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 07:12:35PM +0100, Christoph Hellwig wrote:
> Okay.  Now that we get into the details I've also added some renaming,
> release_mem becomes release_tty and the new factored out function is
> release_one_tty.  The difference is documented in the kdoc comments.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Alan Cox <alan@redhat.com>


