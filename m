Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbXDUXH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbXDUXH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXDUXH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:07:27 -0400
Received: from buraja.hst.terra.com.br ([200.176.10.198]:36038 "EHLO
	buraja.hst.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbXDUXH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:07:26 -0400
X-Terra-Karma: -2%
X-Terra-Hash: 93346dff61638d0492cae9d8b0d1ed83
Message-ID: <462A9926.2030303@centralinf.com.br>
Date: Sat, 21 Apr 2007 20:07:18 -0300
From: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7: HPET enabled freeze my machine at boot
References: <4627D7CF.3070002@centralinf.com.br> <1f1b08da0704201453i1b2388der1dfe778633fbf6ea@mail.gmail.com>
In-Reply-To: <1f1b08da0704201453i1b2388der1dfe778633fbf6ea@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John,

Boot ok with clocksource=acpi_pm and HPET enabled.
Any clue?

john stultz wrote:
> On 4/19/07, guilherme <guilherme@centralinf.com.br> wrote:
>> Hi,
>>
>> If i enable "High Resolution Timer Support", my machine stops here at 
>> boot:
>>
>> Clocksource tsc unstable (delta = -297340790165 ns)
>> Time: hpet clocksource has been installed.
>>
>> If i disable HPET, it boots fine.
> 
> Hmmm.. What happens if you boot w/ clocksource=acpi_pm ?
> 
> 
