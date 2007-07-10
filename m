Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbXGJUra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbXGJUra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbXGJUrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:47:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554AbXGJUrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:47:19 -0400
Message-ID: <4693EF8E.9070403@zytor.com>
Date: Tue, 10 Jul 2007 13:43:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de> <4693AA56.9040109@zytor.com> <551EA412-3D35-4BCD-ACAE-B6A7BE3CBF9B@kernel.crashing.org>
In-Reply-To: <551EA412-3D35-4BCD-ACAE-B6A7BE3CBF9B@kernel.crashing.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
> 
>> I'm a bit surprised about the claim w.r.t. -fno-unit-at-a-time (although
>> I guess that is the default and one would thus typically not see this.)
> 
> -fno-unit-at-a-time is the default on three year old compilers,
> yes.  Newer compilers have unit-at-a-time enabled by default.
> 

As I said, never mind.  "Unit at a time" does something totally
different from what I somehow had gotten into my head it did.

	-hpa
