Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXGHRYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXGHRYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 13:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXGHRYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 13:24:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbXGHRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 13:24:38 -0400
Message-ID: <46911DD1.9040100@anagramm.de>
Date: Sun, 08 Jul 2007 19:24:33 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce panic_gently
References: <Pine.LNX.4.58.0707060034330.18989@be1.lrz> <468DF5D9.4040803@anagramm.de> <468E833C.6030300@redhat.com>
In-Reply-To: <468E833C.6030300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+DUpjJkI4HZIb4wMPqbNoIbnC2/heQkyMO7hH
 VQjJAMZ77PUflPIuRyEPRPfO/G/dybRKjXzNoSMYCsuzb9ZWfU
 pO2kulPsnfJ760Z1hpERA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert schrieb:
> On 07/06/2007 03:57 AM, Clemens Koller wrote:
>> The 180seconds reboot timeout also doesn't make sense here. The problem
>> won't go away after a reboot without user interaction.
> 
> What about GRUB fallbacks? The fallback image/kernel will start
> automatically on reboot if you use that feature.

Yes, you are right.

Regards,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
