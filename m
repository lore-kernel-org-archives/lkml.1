Return-Path: <linux-kernel-owner+w=401wt.eu-S1751236AbZGSTJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbZGSTJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 15:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZGSTJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 15:09:01 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:64068 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGSTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 15:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I7nNnSicF6Ms0KUCX4dH0tqHoIMeqqXu24hni0NBA/m4l8rpJbyXAode5JQTcZE6tQ
         tBjK6R26RubZoWdJcKxB+r2R+RnLUgPWBFREN2HfVKrMyhPeW2USdQPi2wS7PwbTvlE6
         C0/Vs4oOW505Ckjw4P3NUJwvc60SON2sK5EfM=
MIME-Version: 1.0
In-Reply-To: <20090719182533.GA11496@srcf.ucam.org>
References: <4A61FE7D.9080409@tuffmail.co.uk>
	 <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>
	 <4A623490.50305@tuffmail.co.uk>
	 <8db1092f0907190028o334371d7g798c1e8cb9a5744b@mail.gmail.com>
	 <4A635618.3070507@tuffmail.co.uk>
	 <8db1092f0907191110p2d3c2c45je61bda6365ed1468@mail.gmail.com>
	 <20090719182533.GA11496@srcf.ucam.org>
Date: Sun, 19 Jul 2009 21:08:58 +0200
Message-ID: <8db1092f0907191208m12bcaa5ev3c5606e6e3eb87bd@mail.gmail.com>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/19 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Sun, Jul 19, 2009 at 08:10:23PM +0200, Maciej Rutecki wrote:
>
>> LED from wifi/bluetooth button sometimes flashing(!)
>
> The LED will flash if wifi is enabled and bluetooth isn't.
>

Thanks. I didn't know about it.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
