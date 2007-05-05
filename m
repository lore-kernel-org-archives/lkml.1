Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbXEEQ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbXEEQ0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXEEQ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:26:17 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:18419 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331AbXEEQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oaQWO+jeAoK23z/MO37DGYh1cU+DykCBdBGZQoxQi27mOGVE/KWONaai0xlSzVLRwzu+ZxxYlxrrXM6DltntVLkGGIt/YO4LXZ3QfR+sqvNaI9aOPHgXWeiAUVJIYRoFtODkhGky+KcZMrPoeYvuClHRqu0J33s/t1IFnESmh9k=
Message-ID: <5486cca80705050926j5c33eaf3m8723b76d4759fc5a@mail.gmail.com>
Date: Sat, 5 May 2007 18:26:12 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1178381739.3379.11.camel@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	 <463BC223.2040304@microgate.com> <1178353618.3472.1.camel@x2>
	 <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
	 <463CB429.6050201@microgate.com> <1178381287.3379.8.camel@x2>
	 <1178381739.3379.11.camel@x2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/5, Paul Fulghum <paulkf@microgate.com>:
> On Sat, 2007-05-05 at 11:08 -0500, Paul Fulghum wrote:
> > I would argue that cdc-acm should do the same as the serial driver.
>
> Try this patch for the usb ports. (I don't have that hardware)

Building... thanks.

The HW is a cypress demo-board for their micro-controllers with an USB
interface. Linux had recognized it as a cdc_acm modem, but it's only a
very simple serial device that can stream data on request.

  ~ Antonio
