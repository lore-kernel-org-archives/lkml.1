Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbXCMDGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbXCMDGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 23:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbXCMDGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 23:06:03 -0400
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:42757 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbXCMDGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 23:06:01 -0400
From: Con Kolivas <kernel@kolivas.org>
To: David Miller <davem@davemloft.net>
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
Date: Tue, 13 Mar 2007 14:05:23 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <200703121058.11966.kernel@kolivas.org> <20070312.164652.108743760.davem@davemloft.net>
In-Reply-To: <20070312.164652.108743760.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131405.23482.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 10:46, David Miller wrote:
> From: Con Kolivas <kernel@kolivas.org>
> Date: Mon, 12 Mar 2007 10:58:11 +1100
>
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.
> >30.patch
>
> FWIW, this boots and seems to work well on sparc64.  Tested
> on UP SunBlade1500 and 24cpu Niagara T1000.

Very nice. Thanks for the feedback and I'm sorry you have to work with such 
lousy hardware.

-- 
-ck
