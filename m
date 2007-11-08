Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbXKHKYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbXKHKYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXKHKYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:24:42 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:39368 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578AbXKHKYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:24:41 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 8 Nov 2007 11:24:11 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
cc: "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/6] x86: apicdef.h unification
Message-ID: <20071108102411.GG20836@erda.amd.com>
References: <20071106183645.951275000@amd.com>
 <alpine.LFD.0.9999.0711062130200.3628@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.0.9999.0711062130200.3628@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 08 Nov 2007 10:24:11.0969 (UTC)
 FILETIME=[81453310:01C821F1]
X-WSS-ID: 6B2C3C4424S1815974-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On 06.11.07 21:32:12, Thomas Gleixner wrote:
> Thanks for doing this, but please check the x86 git repository
> (cleanup / mm branch) for stuff which has been worked on already.
> 
> Maybe we need some coordination for this.

Is it for sure that the x86/cleanup tree will go upstream soon and the
source will not change as much? The question is what code base to use
for new patches? I want to keep the porting effort as small as
possible.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


