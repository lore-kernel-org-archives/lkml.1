Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641Ab0AZIyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0AZIyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160Ab0AZIye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:54:34 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:5199 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0AZIye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZKSiK7TwLTTtT1urQKbwIVRbuheF7yEu9zoEMnC0MfDSWV9EkXL2ulOVAjVFOt01HS
         GbXhlQrk7SvLg2vBgPQUyf6vTyFm7T2+Ds745BUwEvFh1sw8d7fyw8K7rd2xWdk/vskV
         EU+t76v8Up39cbxnj6DlGdHmxR+0HFJxa+9Wc=
MIME-Version: 1.0
In-Reply-To: <20100126083500.GA20792@pengutronix.de>
References: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de> 
	<20100125013421.GL26562@trinity.fluff.org> <4B5CFEBE.2070906@gmail.com> 
	<20100125074242.GA12480@pengutronix.de> <4B5E092B.3070801@gmail.com> 
	<f17812d71001252201n215f2a9y1906fef630726dbe@mail.gmail.com> 
	<20100126083500.GA20792@pengutronix.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 26 Jan 2010 16:54:13 +0800
Message-ID: <f17812d71001260054g57b282c4n90977cc76d521f89@mail.gmail.com>
Subject: Re: [PATCH] RFC: make struct platform_driver.id_table const
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Vikram Dhillon <opensolarisdev@gmail.com>,
       linux-arm-kernel@lists.infradead.org, Eric Miao <eric.miao@marvell.com>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/26 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Greg,
>
> On Tue, Jan 26, 2010 at 02:01:15PM +0800, Eric Miao wrote:
>> I seems to remember a similar patch sent to GregKH weeks ago and
>> should be sitting somewhere but this one looks to be more complete.
> Yes, it's
>        gregkh-2.6/gregkh-05-driver-core/driver-core-make-platform_device_id-table-const.patch
>
> Below you can find the current state with all Acks it has got until now.
> (Eric: I considered your mail as Ack, too.  OK?)

OK.

> As I don't know how to change the log message with an incremental patch
> you have to tell me if you prefer this way.

Greg?
