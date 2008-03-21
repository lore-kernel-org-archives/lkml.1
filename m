Return-Path: <linux-kernel-owner+w=401wt.eu-S1761920AbYCUUmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920AbYCUUmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762121AbYCUUlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:41:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762105AbYCUUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:41:51 -0400
Message-ID: <47E41D7D.9050409@zytor.com>
Date: Fri, 21 Mar 2008 13:41:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ultrastor.c is a bit-rot
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org>
In-Reply-To: <20080317152344.GE26285@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> 
> VESA Local Bus.  It was (in some sense) the predecessor of AGP.  We
> treat it like ISA inside the kernel.  On x86, EISA depends on ISA, so
> the dependency, while wrong, does not affect any x86 users who have an
> EISA card.
> 

Well, one can say VLB was to ISA (a souped-up ISA bus with some of the 
worst limitations removed) what AGP is to PCI...

	-hpa
