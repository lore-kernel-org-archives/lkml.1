Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbXJQTss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbXJQTss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXJQTsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:48:41 -0400
Received: from exchange.comtrol.com ([204.73.219.163]:53052 "EHLO
	Exchange.comtrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbXJQTsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:48:40 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: RocketPort Linux driver errors on module reload
Date: Wed, 17 Oct 2007 14:48:39 -0500
Message-ID: <B1F576FE19C55C43B8D2E31F061B50C062C3EF@exchange.comtrol.com>
In-Reply-To: <471663EE.6090602@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RocketPort Linux driver errors on module reload
Thread-Index: AcgQ9ONzah1paUmVREayCinp3MkaiQAAKrXQ
From: "Nick Thompson" <Nick.Thompson@comtrol.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jiri Slaby [mailto:jirislaby@gmail.com]
>Sent: Wednesday, October 17, 2007 2:35 PM
>To: Nick Thompson
>Cc: linux-kernel@vger.kernel.org
>Subject: Re: RocketPort Linux driver errors on module reload
>
>
>On 10/17/2007 07:06 PM, Nick Thompson wrote:
>> I've been wanting to get the driver that is included in the kernel up to date, and there >>is an active project here at comtrol to get the current code (driver version 3.08 beta) up >>to Linux kernel programming standards. The driver version that is included in the kernel     >>(and has been patched a bit I'm sure since it's been in there a while)is version 2.09. The >>latest version (3.08 beta) can be obtained from: 
>
>the easiest way is to get diff -u 2.09 3.08 and port it by hand, at least I
>ususally do it this way.
>
>> ftp://ftp.comtrol.com/beta/rport/drivers/u_pci/linux/rocketport-linux-3.08.tar.gz
>> 
>> If anyone has any helpful pointers (no pun intended) or comments on the code, I'd love to >>listen. 
>
>Convert to pci probing and in-kernel firmware loading :). The code is big mess
>due to ifdefs and much unneeded material, it's likely impossible to say this is
>wrong and this not, if you won't post a patch, where people will see the changes
>you want to make. Then you will have feedback :).
>
>regards,
>-- 
>Jiri Slaby (jirislaby@gmail.com)
>Faculty of Informatics, Masaryk University

Jiri,
 Thanks a lot for the feedback, it's very much appreciated. Like I said, there is an active project here at Comtrol to get 3.08 beta up to Linux kernel coding standards, once that gets somewhere near done, a patch will be forthcoming.

Thanks for taking the time to write.

Regards,

Nick

Nick Thompson
Technical Support Specialist nick.thompson@comtrol.com
Comtrol Corporation ftp://ftp.comtrol.com
6655 Wedgwood Rd. Ste 120 http://www.comtrol.com
Maple Grove, MN. 55311 Sales: (800)GO-ROCKET
