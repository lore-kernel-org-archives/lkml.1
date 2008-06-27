Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYF0CBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYF0CBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYF0CBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:01:00 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:33435 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbYF0CA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:00:59 -0400
Subject: Re: [v4l-dvb-maintainer] saa7134 duplicate device in module, but
	different device_data?
From: hermann pitton <hermann-pitton@arcor.de>
To: Ben Collins <ben.collins@canonical.com>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1214528392.4480.40.camel@pc10.localdom.local>
References: <1214501094.7150.29.camel@cunning>
	 <1214524580.4480.32.camel@pc10.localdom.local>
	 <1214525206.7150.118.camel@cunning>
	 <1214528392.4480.40.camel@pc10.localdom.local>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 03:58:33 +0200
Message-Id: <1214531913.4480.53.camel@pc10.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Freitag, den 27.06.2008, 02:59 +0200 schrieb hermann pitton:
> Am Donnerstag, den 26.06.2008, 20:06 -0400 schrieb Ben Collins:
> > On Fri, 2008-06-27 at 01:56 +0200, hermann pitton wrote:

[snip]
> I do agree and will be happy with any patch you provide to get it out of
> sight ;)
> 

Ben,

just move the duplicate stuff out of the auto detection until we have
something better and send that patch. 

Previous hopes, to be able to do something more, are for sure
disappointed now and no reason to wait any longer.

We rely on the eeprom gimmicks and they did use them mainly previously
to shot down each other as best they can ...

Cheers,
Hermannn




