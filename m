Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYHKQy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYHKQy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYHKQys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:54:48 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:6653 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYHKQyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:54:47 -0400
X-BigFish: VPS-26(z21eWz1447R1442Jzzzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K5G4AU-01-JO1-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Regression in 2.6.27-rc2 in acpi_processor_init()
Date: Mon, 11 Aug 2008 11:54:38 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC5E@sausexmb4.amd.com>
In-Reply-To: <1218339276.6671.43.camel@yakui_zhao.sh.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression in 2.6.27-rc2 in acpi_processor_init()
Thread-Index: Acj6mCAIaRLDZlRdQl+Ch9SLCYS9eQBOr1ZA
References: <6453C3CB8E2B3646B0D020C112613273C5AC59@sausexmb4.amd.com> <200808082302.11358.rjw@sisk.pl> <1218339276.6671.43.camel@yakui_zhao.sh.intel.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "lkml" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 11 Aug 2008 16:54:38.0877 (UTC) FILETIME=[F1386CD0:01C8FBD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    Will you please attach the output of acpidump on bug 11287?
>    Of course it will be great if you can enable CONFIG_ACPI_DEBUG and
> CONFIG_CPUFREQ_DEBUG in kernel configuration  and boot the system with
> the option of "cpufreq.debug=7 acpi.debug_layer=0x01010000
> acpi.debug_level=0x17".
>    After the system is booted, please attach the output of dmesg.
>    Please do the above test on both kernel 2.6.27-rc1 and 2.6.27-rc2.

False alarm.  I had acpi=off set in my command line for some
reason.

Thanks for the offer of help.

-Mark Langsdorf
Operating System Research Center
AMD

