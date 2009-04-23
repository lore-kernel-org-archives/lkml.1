Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZDWR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZDWR35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZDWR32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:29:28 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:33532 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752946AbZDWR31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:29:27 -0400
Message-ID: <49F0A569.1040701@pardus.org.tr>
Date: Thu, 23 Apr 2009 20:29:13 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ross Alexander <Ross.Alexander@EU.NEC.COM>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ACPI / powernow-k8 problems with M4A78T-E (AM3) and 2.6.30-rc3
References: <F632EDDF1017D445AE61401A3E974CC082EA4131CE@EUEXCLU01.EU.NEC.COM>
In-Reply-To: <F632EDDF1017D445AE61401A3E974CC082EA4131CE@EUEXCLU01.EU.NEC.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Alexander wrote:
> With BIOS version 0801 the powernow-k8 faulting.
>   
Yes I'm having the exact warning with my system too. I already reported
this 2-3 days ago and
Borislav Petkov said that the backtrace was intentional:

"

For the reasoning behind why you get a backtrace instead of simple
warning see

79cc56af9fdbeaa91f50289b932d0959b41f9467
a0ad05c75aa362c91f4d9cd91ff375a739574dd8

"

I'd really like to know if that warning/firmware bug is leaving the kernel in an inconsistent state
because my keyboard also doesn't work if I don't give acpi=off during the boot.

I never upgraded my BIOS and I wonder why my keyboard is broken after a normal booting sequence.
The system was charmly working with 2.6.29_rc8, didn't have time to try 2.6.29{.1}.

Any helpful comment will be appreciated.

Regards,

Ozan Çağlayan
http://www.pardus.org.tr/eng


