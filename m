Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbXJWCeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbXJWCeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXJWCeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:34:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36940 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXJWCeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:34:02 -0400
Date: Tue, 23 Oct 2007 08:03:55 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Blunck <jblunck@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] Use struct path in struct nameidata
Message-ID: <20071023023355.GA7829@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com> <20071022135758.GA17051@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022135758.GA17051@lst.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 03:57:58PM +0200, Christoph Hellwig wrote:
> 
> Any reason we've got this patchset posted by three people now? :)

Two reasons actually !

- The set of patches posted by Jan last was on 2.6.23-rc8-mm1. So I
thought let me help Andrew a bit by making them available on latest
-mm :) And I didn't know that these were already under consideration
by Andrew.

- The set of patches posted by Jan didn't even pass compile test for me.
So I made sure that the patches compiled and worked on x86, x86_64 and powerpc.

Regards,
Bharata.
