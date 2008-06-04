Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbYFDKyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbYFDKyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760036AbYFDKyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:54:16 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:40611 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbYFDKyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:54:13 -0400
Message-ID: <4846744A.9040204@diamondcut.com.br>
Date: Wed, 04 Jun 2008 07:54:02 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, devzero@web.de
Subject: Re: [Bug 10797] Something is consuming power after shutdown
References: <483AB443.6020807@diamondcut.com.br> <20080531074433.GE5405@ucw.cz> <4842BB89.5090908@diamondcut.com.br> <20080602192012.GA7748@ucw.cz>
In-Reply-To: <20080602192012.GA7748@ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Renato S. Yamane wrote:
>> Pavel Machek wrote:
>>> (And yes, your hw is broken; on pc it is traditionaly hw
>>> responsibility to power machine down.)
>>
>> OK, I try do this but I think this is very difficult because demand
>> power is very low and is not enought to do hot some component. But I
>> will try.
>>
>> I don't think that my hardware is broked because I don't have this kind
>> of problem on Kernel <=2.6.22 or in other OS.
>> Track: <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> 
> Can you try to find out when that started happening?
> does it still happen with acpi=off?
> does it each too much power if you use 4second hold of power button to
> shut it down from running linux?

With acpi=off this problem don't happening, but a lot of other problem
happening (as fan control).

I will try halt my laptop holding power button today and report you
tomorrow.

Best regards,
Renato S. Yamane
