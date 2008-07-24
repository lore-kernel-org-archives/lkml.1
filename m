Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYGXXU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYGXXU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYGXXUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbYGXXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:20:16 -0400
Date: Thu, 24 Jul 2008 16:16:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
In-Reply-To: <20080724230658.GP14380@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0807241616241.8109@nehalem.linux-foundation.org>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org>
 <20080724202728.GL14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org> <20080724212351.GM14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241431180.8109@nehalem.linux-foundation.org> <20080724222523.GN14380@linux-os.sc.intel.com>
 <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org> <20080724230658.GP14380@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, Suresh Siddha wrote:
> 
> BTW, while you are at it, please move save_i387() aswell, to be consistent
> and clean.

Ack. Will do.

		Linus
