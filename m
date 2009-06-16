Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbZFPToh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbZFPToh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZFPTo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:44:29 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2769 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbZFPTo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:44:28 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm@lists.arm.linux.org.uk" <linux-arm@lists.arm.linux.org.uk>
cc: "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Tue, 16 Jun 2009 12:44:25 -0700
Subject: QUESTION: new arch/arm/mach-bcmring code submission
Thread-Topic: QUESTION: new arch/arm/mach-bcmring code submission
Thread-Index: Acnuutp/dsSp7RrKShqdXJZipEPzkg==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB2592D730@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6629299638G9626522-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Our team in Broadcom plan to submit our code of a new ARM11 SoC support to kernel.org.
As we have no experience in doing this, I hope that we can get some more information regarding the code submission.

1. We have a whole lot of OS-less csp (chip support package) code that is used in our drivers and arch code. We will release them as GPL but we want to keep and maintain them in our own csp directories.  Can we put them under arch/arm/mach-bcmring/csp and arch/arm/mach-bcmring/include/csp directories?  If not, what's the proper way to do that?

2. We have driver header files which are currently kept in the include/linux/broadcom directory.  Where is the proper place to put our driver header files in Linux kernel?  Any guidelines?

3. Do I need to submit our code to any maintainer or just submit to LKML?


Thanks a lot, 

------------- 
Leo Hao Chen
Software Engineer
Broadcom Canada Inc.
604-233-8694

