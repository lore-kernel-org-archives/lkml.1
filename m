Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbXEISOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbXEISOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbXEISOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:14:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbXEISOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:14:41 -0400
Message-ID: <46420F89.5030202@redhat.com>
Date: Wed, 09 May 2007 14:14:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.21
References: <1178673459.3737.114.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1178673459.3737.114.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> This should be the second half of the SCSI tree, mainly assorted driver
> updates and fixes.  The patch is available from:
> 

Is Doug Chapman's patch for mptspi going in?

http://marc.info/?l=linux-scsi&m=117857313402574&q=raw

[PATCH] fix for BZ 8426 - massive slowdown on SCSI CD/DVD drive
