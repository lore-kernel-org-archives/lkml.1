Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZBDIfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZBDIfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZBDIem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:34:42 -0500
Received: from mailout.borland.com ([63.175.76.156]:32214 "EHLO
	mail.borland.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbZBDIek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:34:40 -0500
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 03:34:40 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-puzzleid: {87D37BC3-31D0-48FD-9344-AE2F6DB7D082}
x-cr-hashedpuzzle: BclN EsnK EuSM Id7k MW/s OGcR UMfk VHZL jeRv md3D oQ7d rsGq stJg tPl9 vEJs AARQ/g==;6;YQB2AG8AcgBvAG4AdABzAG8AdgBAAHIAdQAuAG0AdgBpAHMAdABhAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AHAAcABjAC0AZABlAHYAQABvAHoAbABhAGIAcwAuAG8AcgBnADsAbQBpAG4AZwBvAEAAZQBsAHQAZQAuAGgAdQA7AHAAYQB1AGwAdQBzAEAAcwBhAG0AYgBhAC4AbwByAGcAOwBzAHIAbwBzAHQAZQBkAHQAQAByAGUAZABoAGEAdAAuAGMAbwBtAA==;Sosha1_v1;7;{87D37BC3-31D0-48FD-9344-AE2F6DB7D082};dQBzAGgAYQByAGEAbgBpAC4AawBvAG4AdQBkAHUAbABhAEAAYgBvAHIAbABhAG4AZAAuAGMAbwBtAA==;Wed, 04 Feb 2009 08:17:24 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAHYAMgBdACAAZgB0AHIAYQBjAGUAOgAgAE8AbgAgAFAAbwB3AGUAcgBQAEMAIAB3AGUAIABkAG8AbgAnAHQAIABuAGUAZQBkACAAZgByAGEAbQBlACAAcABvAGkAbgB0AGUAcgBzACAAZgBvAHIAQwBBAEwATABFAFIAXwBBAEQARABSAHMA
Content-class: urn:content-classes:message
Subject: RE: [PATCH v2] ftrace: On PowerPC we don't need frame pointers forCALLER_ADDRs
Date: Wed, 4 Feb 2009 00:17:24 -0800
Message-ID: <FBBDF103002CF543AB3BDA6D560847120214F716@USSVS-EXCH01.amer.borl.net>
In-Reply-To: <20090203145649.GA19955@oksana.dev.rtsoft.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] ftrace: On PowerPC we don't need frame pointers forCALLER_ADDRs
Thread-Index: AcmGD+oDpEYqxXnCTPSYcS32wGI5IAAkQ5/g
References: <20090131190650.GA4284@oksana.dev.rtsoft.ru><1233534919.18767.69.camel@pasglop><1233583455.16878.3.camel@localhost.localdomain> <20090203145649.GA19955@oksana.dev.rtsoft.ru>
From: "Usha Rani Konudula" <UshaRani.Konudula@borland.com>
To: <avorontsov@ru.mvista.com>, "Steven Rostedt" <srostedt@redhat.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Paul Mackerras" <paulus@samba.org>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
X-OriginalArrivalTime: 04 Feb 2009 08:19:29.0735 (UTC) FILETIME=[4D0D6570:01C986A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsubscribe linux-kernel

