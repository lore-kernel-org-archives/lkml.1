Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbXE0PEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbXE0PEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXE0PD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:03:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40020 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbXE0PDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:03:55 -0400
Message-ID: <46599DD9.4020408@garzik.org>
Date: Sun, 27 May 2007 11:03:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] SCSI/initio conversion to PCI driver API
References: <20070527145200.GA17017@havoc.gtf.org> <20070527145955.GE17085@havoc.gtf.org>
In-Reply-To: <20070527145955.GE17085@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Prior simplifications in this patchset now permit a minimal conversion
> to the new PCI API.
> 
> Further improvements and simplifications are certainly possible; those
> should be presented in a separate patchset.
> 
> DO NOT APPLY (yet).  For feedback (and testers?) only.


This only applies to patch #5.

Patches 1 through 4 should go upstream, IMO.

	Jeff


