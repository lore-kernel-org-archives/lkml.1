Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYCWJzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYCWJzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYCWJzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 05:55:00 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26494 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753874AbYCWJy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 05:54:59 -0400
Message-ID: <47E628DF.6070301@panasas.com>
Date: Sun, 23 Mar 2008 11:54:39 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ultrastor.c is a bit-rot
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org> <47E41D7D.9050409@zytor.com>
In-Reply-To: <47E41D7D.9050409@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Mar 2008 09:54:44.0296 (UTC) FILETIME=[EBD5B480:01C88CCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21 2008 at 22:41 +0200, "H. Peter Anvin" <hpa@zytor.com> wrote:
> Matthew Wilcox wrote:
>> VESA Local Bus.  It was (in some sense) the predecessor of AGP.  We
>> treat it like ISA inside the kernel.  On x86, EISA depends on ISA, so
>> the dependency, while wrong, does not affect any x86 users who have an
>> EISA card.
>>
> 
> Well, one can say VLB was to ISA (a souped-up ISA bus with some of the 
> worst limitations removed) what AGP is to PCI...
> 
> 	-hpa

Hmm interesting, so someone took the VGA thing and made a storage device
for it. Did that ever happen with AGP? Any AGP scsi cards. I guess I can
Google for it.

Boaz
