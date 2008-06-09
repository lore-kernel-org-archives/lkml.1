Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbYFILPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbYFILPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbYFILPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:15:47 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:37160 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbYFILPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:15:47 -0400
Message-ID: <484D10DE.30704@diamondcut.com.br>
Date: Mon, 09 Jun 2008 08:15:42 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, devzero@web.de
Subject: Re: [Bug 10797] Something is consuming power after shutdown
References: <483AB443.6020807@diamondcut.com.br> <20080531074433.GE5405@ucw.cz> <4842BB89.5090908@diamondcut.com.br> <20080602192012.GA7748@ucw.cz> <4846744A.9040204@diamondcut.com.br>
In-Reply-To: <4846744A.9040204@diamondcut.com.br>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Renato S. Yamane wrote:
> Pavel Machek wrote:
>> Renato S. Yamane wrote:
>>> Pavel Machek wrote:
>>>> (And yes, your hw is broken; on pc it is traditionaly hw
>>>> responsibility to power machine down.)
>>> OK, I try do this but I think this is very difficult because demand
>>> power is very low and is not enought to do hot some component. But I
>>> will try.
>>>
>>> I don't think that my hardware is broked because I don't have this kind
>>> of problem on Kernel <=2.6.22 or in other OS.
>>> Track: <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
>> Can you try to find out when that started happening?
>> does it still happen with acpi=off?
>> does it each too much power if you use 4second hold of power button to
>> shut it down from running linux?
> 
> With acpi=off this problem don't happening, but a lot of other problem
> happening (as fan control).
> 
> I will try halt my laptop holding power button today and report you
> tomorrow.

If I hold power button to force shutdown I don't have this problem with
battery charge.

Best regards,
Renato S. Yamane
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFITRDdrf2L358fCLsRAuKUAJ9N2HVzuFnOA5zDes286/F8LgPfNgCePS4Z
YMWoFzYl+eF3/do1Je9oly8=
=31/g
-----END PGP SIGNATURE-----
