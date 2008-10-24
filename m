Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbYJXWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbYJXWe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYJXWeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:34:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:26809 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbYJXWeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:34:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,481,1220252400"; 
   d="scan'208";a="395759286"
From: "Moore, Robert" <robert.moore@intel.com>
To: Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: ACPI mailing list <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Date: Fri, 24 Oct 2008 15:34:14 -0700
Subject: RE: ACPI warning in 2.6.28-rc1
Thread-Topic: ACPI warning in 2.6.28-rc1
Thread-Index: Ack2JS/XPlJIvQLBTbeEa+db1cdqegAA2ufQ
Message-ID: <4911F71203A09E4D9981D27F9D8308580AA800C4@orsmsx503.amr.corp.intel.com>
References: <b637ec0b0810241509j43a6bfc9q506dc16a612e7f06@mail.gmail.com>
In-Reply-To: <b637ec0b0810241509j43a6bfc9q506dc16a612e7f06@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please send the acpidump for the machine so we can look at the method.
Thanks,
Bob


>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Fabio Comolli
>Sent: Friday, October 24, 2008 3:09 PM
>To: Linux Kernel Mailing List
>Cc: ACPI mailing list; Len Brown
>Subject: ACPI warning in 2.6.28-rc1
>
>Hi all.
>As the subject says:
>
>ACPI Warning (nspredef-0858): \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Return
>Package type mismatch at index 11 - found Buffer, expected String
>[20080926]
>
>No functional problems so far.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
