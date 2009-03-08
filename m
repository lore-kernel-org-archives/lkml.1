Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZCHBCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZCHBCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 20:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZCHBCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 20:02:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZCHBCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 20:02:22 -0500
Message-ID: <49B31909.9020407@kernel.org>
Date: Sat, 07 Mar 2009 17:02:01 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: AMD 64 Box is not able to boot with latest -tip
References: <1236441089.3285.6.camel@localhost.localdomain>
In-Reply-To: <1236441089.3285.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> My AMD 64 Box was not able to boot with latest -tip and kernel is
> dumping.
> 
> Because of hot weather and not proper cooling I cannot debug the problem
> so only thing I can tell is:
> 
> BAD : cb553adb4e83bc
> 
> Good : f0ef03985130287c6c
> 

You realize you left absolutely no usable information in that post, I
hope... not a single bit of detail about the system other than it having
an AMD CPU.

	-hpa
