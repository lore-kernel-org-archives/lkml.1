Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab0BQS1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:27:17 -0500
Received: from mail-qy0-f200.google.com ([209.85.221.200]:41389 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0BQS1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:27:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=oucItdpuj1JrgydCeuMomAEyzQ1WTlCnsYpsNBfV4npGfrrc3nn4Ci6naEn22A7136
         6idOfC0r9uo4VAHB1X2VxO6Kli01t8DpizI4WM2hSjby4Z55I5IfKlmCCmSCmnWqa6st
         15zLrs4gtzbyOYqucbhARbDBcCHD01HxeD/CM=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 19:27:06 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.12r4; KDE/4.4.0; x86_64; ; )
Cc: david@lang.hm, Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com> <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm> <20100217181016.GA14983@emergent.ellipticsemi.com>
In-Reply-To: <20100217181016.GA14983@emergent.ellipticsemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002171927.07051.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch 17 Februar 2010, Nick Bowler wrote:
> On 09:41 Wed 17 Feb     , david@lang.hm wrote:
> > for a distro that is trying to make one kernel image run on every
> > possible type of hardware features like initramfs (and udev, modeules,
> > etc) are wonderful.
> > 
> > however for people who run systems that are known ahead of time and
> > static (and who build their own kernels instead of just relying on the
> > distro default kernel), all of this is unnessesary complication, which
> > leaves more room for problems to creep in.
> 
> Such people can easily construct an initramfs containing busybox and
> mdadm with a shell script hardcoded to mount their root fs and run
> switch_root.  It's a ~10 minute jobbie that only needs to be done once.


and even better when you don't have to do that one time job at all.

btw, what about additional delay? 


Glück Auf,
Volker
