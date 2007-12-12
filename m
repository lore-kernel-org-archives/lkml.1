Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbXLLVjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbXLLVjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXLLVjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:39:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbXLLVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:39:39 -0500
Message-ID: <476054FB.3000007@zytor.com>
Date: Wed, 12 Dec 2007 13:39:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Phillip Susi <psusi@cfl.rr.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Remove all definitions with fastcall
References: <1197491364.21291.14.camel@brick>  <47605238.9020402@cfl.rr.com> <1197495102.21291.28.camel@brick>
In-Reply-To: <1197495102.21291.28.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Wed, 2007-12-12 at 16:27 -0500, Phillip Susi wrote:
>> Harvey Harrison wrote:
>>> fastcall is always defined to be empty, remove it from arch/x86
>> Why is it always defined to be empty?  Why isn't it used anymore?
>>
> 
> It was a leftover from before regparm(3) became the default on x86-32.
> 

s/default/obligatory/

	-hpa
