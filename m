Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXEAURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXEAURT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXEAURT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:17:19 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:3960 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbXEAURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:17:18 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org, linux-kernel@vger.kernel.org
Subject: Re: [ck] 2.6.21-ck1-rc1
Date: Tue, 1 May 2007 22:17:14 +0200
User-Agent: KMail/1.9.6
References: <200705011618.57640.kernel@kolivas.org> <200705012143.38677.Martin@lichtvoll.de> (sfid-20070501_215854_476326_4EDBE198)
In-Reply-To: <200705012143.38677.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705012217.14395.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 01 Mai 2007 schrieb Martin Steigerwald:
> Am Dienstag 01 Mai 2007 schrieb Con Kolivas:
> > Let's call this a release candidate for 2.6.21-ck1. I've managed to
> > be well enough for enough time to bang this out.
> >
> > http://ck.kolivas.org/patches/pre-releases/2.6.21/2.6.21-ck1-rc1/

[...]

> Hello Con!
>
> Works nicely here. Did my usual stress testing... music playback is
> absolutely smooth.
>
> I will test it during the next 1-2 days at least.
>
> Got ridicolous long releasenames now ;-):
> 2.6.21.1-tp23-sws2-2.2.9.13-ck1-rc1-hotfix-sched-idleprio
> 2.6.21.1-tp42-sws2-2.2.9.13-ck1-rc1-hotfix-sched-idleprio
>
> Feels really very responsive. Those other patches seem to add to the
> responsiveness to sd-0.46 quite well. Can't really tell whether cfs-v7
> or cfs-v8-rc3 is really a slight bit smoother or not. Subjectively

[as I initially thought when comparind sd-0.46 without other ck patches 
with cfs]

> seems to be pretty much the same now.

Hmmm, maybe thats the desktop tune patch which sets rr_interval for SD to 
6 (from the default of 8) making the difference here.

Anyway its very difficult to tell a difference between ck1-rc1 and 
CFS-v8-rc3 from subjective perception. I am really satisfied with both of 
them.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
