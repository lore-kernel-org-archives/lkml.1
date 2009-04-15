Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZDOQBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZDOQBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZDOQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:01:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:16284 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZDOQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:01:15 -0400
Message-ID: <49E604DB.9070702@billgatliff.com>
Date: Wed, 15 Apr 2009 11:01:31 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Ben Nizette <bn@niasdigital.com>, imre.deak@nokia.com,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [REGRESSION] threaded interrupt handler support breaks (some)
 irq handling on AVR32
References: <1239685153.19815.12.camel@linux-51e8.site>	<1239698225.29831.14.camel@linux-51e8.site>	<1239759053.29831.37.camel@linux-51e8.site>	<20090415095710.5c853a7f@hskinnemoen-d830> <20090415103352.5ee43824@hskinnemoen-d830>
In-Reply-To: <20090415103352.5ee43824@hskinnemoen-d830>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> AFAICT, this code has always been dangerous.
>   

Can you propose a better way to handle the problem?  It's a case that 
crops up with a lot of touch screen controllers.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

