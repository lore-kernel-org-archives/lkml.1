Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYDJNFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYDJNFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYDJNEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:04:53 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:4761 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127AbYDJNEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:04:52 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: Starting point: Suspend to RAM on embedded devices?
Date: Thu, 10 Apr 2008 15:04:49 +0200
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301E96266@zuerich.BC-Int.NET>
In-Reply-To: <5699f8f00804100351q427b1a0dxdeb8254b370cb8ed@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Starting point: Suspend to RAM on embedded devices?
Thread-Index: Acia+NOFQPDe4Ih8T5OhmEOr+AwtLQAEizmQ
References: <83116F0A4FF67A4F97BA0B6E408C48E301E96208@zuerich.BC-Int.NET> <5699f8f00804100123q2a9d278arf9b076c91efbbd56@mail.gmail.com> <83116F0A4FF67A4F97BA0B6E408C48E301E96234@zuerich.BC-Int.NET> <5699f8f00804100351q427b1a0dxdeb8254b370cb8ed@mail.gmail.com>
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Apr 2008 13:05:00.0928 (UTC) FILETIME=[7C1D0000:01C89B0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wander Winkelhorst wrote:
> Well, my tomtom one V2 takes a couple (5-10) of seconds to wake up
> again. but that time includes reinitialising the bluetooth chip,
> checking the SD card, restarting the GPS, loading AGPS data and
> resuming the navigation software. If you don't have to do all those
> things it would probably resume a lot faster.    

So Wander,

I had a short look in to the opentom.org project and have got a lot of new questions:
- does the opentom.org kernel support the original "suspend to RAM" functionality of TomToms kernel?
- is there anybody using this functionality?
- has somebody measured the power consuption in the sleep mode?
- the opentom kernel has a file "/arch/arm/kernel/apm.c" which is not in the normal Linux kernels. Where comes this file and other
power saving infrastructure from, where can I grab it, is there anyone else out there using it, on which device?


Thanks,
Marcel

Marcel Wappler
Bridgeco AG
CH-8600 Dübendorf
Switzerland
