Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101Ab0AEVzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0AEVzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803Ab0AEVzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:55:42 -0500
Received: from us-mx4.synaptics.com ([12.178.49.178]:56421 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab0AEVzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:55:41 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 05 Jan 2010 13:00:41 -0800
From: William Manson <WManson@synaptics.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: Christopher Heiny <Cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 5 Jan 2010 13:57:37 -0800
Subject: RE: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen
 Driver
Thread-Topic: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen
 Driver
Thread-Index: AcqMxKMgrX3+QeBSTBOtVApMys2DTQBjJILQ
Message-ID: <7B4B50AC280A5E45A42CD2D364A3CE2F2733F75A3E@USW-EX2K7-1.synaptics-inc.local>
In-Reply-To: <20100103223025.GA4496@core.coreip.homeip.net>
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

Hi Dmitry -

Yes - we are planning on extending support for our new touchpads. As far as I know there is a Linux PS/2 driver in the works but I don't work with that group so I don't know anything about timeframes. I also don't know if it will be made open source or as a proprietary binary - or both. But we are definitely planning on supporting our PS/2 touchpads on Linux.

I will check into the Interfacing Guide and get back to you. The latest is on our web site (http://www.synaptics.com/developers/manuals) but it doesn't have info about multitouch in it. If there is a newer one I'll let you know.

Regards,

William


-----Original Message-----
From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
Sent: Sunday, January 03, 2010 2:30 PM
To: William Manson
Cc: Christopher Heiny; Allie Xiong; linux-kernel
Subject: Re: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver

Hi William,

On Sun, Jan 03, 2010 at 11:48:55AM -0800, William Manson wrote:
> Hi Dmitry -
>
> Thanks for the feedback - we really appreciate it. We are currently
> looking into the issues and the mailer-line wrap issue. We'll be
> re-sending a patch as soon as we get these issue resolved as soon as
> possible.

Could I also ask if you have any plans on extending support for the
newer models of your touchpads (especially multi-touch ones) in the PS/2
version of the driver? Or maybe there is updated version of the
Interfacing Guide that you could share with the community?

Thank you in advance,

Dmitry

