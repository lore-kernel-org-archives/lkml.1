Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYLAMbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYLAMbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYLAMbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:31:21 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:18281 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbYLAMbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:31:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFAJdnM0nCTsYx/2dsb2JhbACBbc0ign0
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Date: Mon, 1 Dec 2008 13:31:25 +0100
User-Agent: KMail/1.9.9
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200812011246.08885.hverkuil@xs4all.nl>
In-Reply-To: <200812011246.08885.hverkuil@xs4all.nl>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011331.25676.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2008, Hans Verkuil wrote:
> Hi Mauro,
>
> Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng for the
> following:
>
> - v4l2: add v4l2_device and v4l2_subdev structs to the v4l2 framework.
> - v4l2-common: add i2c helper functions
> - cs53l32a: convert to v4l2_subdev.
> - cx25840: convert to v4l2_subdev.
> - m52790: convert to v4l2_subdev.
> - msp3400: convert to v4l2_subdev.
> - saa7115: convert to v4l2_subdev.
> - saa7127: convert to v4l2_subdev.
> - saa717x: convert to v4l2_subdev.
> - tuner: convert to v4l2_subdev.
> - upd64031a: convert to v4l2_subdev.
> - upd64083: convert to v4l2_subdev.
> - vp27smpx: convert to v4l2_subdev.
> - wm8739: convert to v4l2_subdev.
> - wm8775: convert to v4l2_subdev.
> - ivtv/ivtvfb: convert to v4l2_device/v4l2_subdev.
>
> All points raised in reviews are addressed so I think it is time to get
> this merged so people can start to use it.

Does linuxtv.org and Mercurial provide the necessary infrastructure to 
integrate those changes into the v4l-dvb repository while not pushing them 
upstream yet ? I'd like to see more people testing (and breaking and 
fixing :-)) your changes before they reach the mainline kernel.

> Reviewed-by: Laurent Pinchart <laurent.pinchart@skynet.be>
> Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Reviewed-by: Andy Walls <awalls@radix.net>
> Reviewed-by: David Brownell <david-b@pacbell.net>
>
> Once this is in I'll start on converting the other i2c drivers.

Best regards,

Laurent Pinchart
