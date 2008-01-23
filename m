Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYAWNCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYAWNCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYAWNCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:02:39 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:3978 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761AbYAWNCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:02:39 -0500
Date: Wed, 23 Jan 2008 14:02:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jon Smirl <jonsmirl@gmail.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCHv2] i2c: adds support for i2c bus on Frescale CPM1/CPM2 
  controllers
Message-ID: <20080123140232.67273b22@hyperion.delvare>
In-Reply-To: <479723CE.5020609@scram.de>
References: <477BEB60.4070703@scram.de>
	<20080103104121.58697148.sfr@canb.auug.org.au>
	<20080123112941.23250948@hyperion.delvare>
	<479723CE.5020609@scram.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Jochen,

On Wed, 23 Jan 2008 12:23:58 +0100, Jochen Friedrich wrote:
> Hi Jean,
> 
> > Do you have an updated patch addressing Stephen's comment?
> > 
> > Note: you'd rather send updates of this patch to the i2c list rather
> > than LKML.
> 
> I'm currently looking at that last patches from Jon and try to make this
> driver fit in there (+ the class override stuff).

I'm not sure what patches exactly you're talking about, but the
aliasing stuff Jon and myself have been working on are still under
debate. Your patch shouldn't assume that any of these patches will go
upstream immediately, so your patch adding the i2c-cpm driver can
ignore them. I'll update the patches before merging them as needed, do
not worry too much about that.

> Note: will do. I just subscribed to this list.

Note hat you do not need to be subscribed to post to the i2c list (but
of course, if you have some interest in Linux i2c development,
subscribing was a good idea anyway.)

-- 
Jean Delvare
