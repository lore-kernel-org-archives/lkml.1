Return-Path: <linux-kernel-owner+w=401wt.eu-S1765692AbXG0EcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765692AbXG0EcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXG0EcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:32:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbXG0Eb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:31:59 -0400
Message-ID: <46A9753A.1010206@zytor.com>
Date: Thu, 26 Jul 2007 21:31:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com> <20070727013615.GC4570@gollum.tnic>
In-Reply-To: <20070727013615.GC4570@gollum.tnic>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
>>
>> The absolute best would be if we could replicate this in simulation
>> (Bochs or Qemu); this would make it very simple to debug.  Would you be
>> willing to try to do that?
> sure, will do, however i'll be busy at work/travelling tomorrow but as soon as i
> get home i'll whip up my qemu and run the kernel in question in it. However,
>  Xudong said that grub 0.97 boots just fine on his machine and i think it'll be
>  better to debug this right on the bare hardware (i.e. my laptop) ...?
>  Suggestions ?

If we can't reproduce the problem in simulation, that itself will tell
us something very important.  If we *can* reproduce it in simulation, it
will be vastly easier to debug.

	-hpa

