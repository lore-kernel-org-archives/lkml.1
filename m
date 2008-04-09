Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYDIIot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYDIIot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYDIIom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:44:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51324 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYDIIol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:44:41 -0400
Date: Wed, 9 Apr 2008 10:49:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Zhao Forrest <forrest.zhao@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       mingo@elte.hu, ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
Message-ID: <20080409084909.GE19010@one.firstfloor.org>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> <87iqyro3rc.fsf@basil.nowhere.org> <20080409083700.GU3700@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409083700.GU3700@mea-ext.zmailer.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I second that.   On my home machine I have early ASUS  AMD x64 board from
> a few years ago.  For it I did buy CPU with this memory mapping hardware
> inside, but the BIOS did not support it correctly until a year or two latter,
> thus I was not able to use all of 4 GB of memory I had installed there.

To be fair the low-end boards often state in their documentation that they only 
got tested with upto 2GB. So strictly you were out of spec if you plug in 4GB.

> Looks like BIOS-writers don't really have test environments for extreme
> far edges of system configurations - "yes, we support --> sales $$$".
> And once product ships, rare extreme users rarely report anything back.

It depends on how much you pay. Higher end boards tend to get tested
in higher end configurations. Low end boards not.

-Andi

