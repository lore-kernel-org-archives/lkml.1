Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYAYBNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYAYBNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYAYBN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:13:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYAYBN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:13:27 -0500
Message-ID: <479936A0.2000604@zytor.com>
Date: Thu, 24 Jan 2008 17:08:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201121530.30671.15.camel@cthulhu.hellion.org.uk> <20080125002054.GA2059@elf.ucw.cz> <47992D0E.2070700@zytor.com> <200801250146.11004.rjw@sisk.pl>
In-Reply-To: <200801250146.11004.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 25 of January 2008, H. Peter Anvin wrote:
>> Pavel Machek wrote:
>>>> I just looked at the ACPI suspend code, and it looks like it hacks its own 
>>>> identity map at runtime.  Pavel, am I reading that code right?
>>> Yes, I think so, I believe we do it on both 32 and 64 bit now.
> 
> For clarity, are you referring to the code in arch/x86/kernel/acpi ?
> 

Yes.

	-hpa
