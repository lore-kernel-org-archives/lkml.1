Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133Ab0AHLNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0AHLNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 06:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669Ab0AHLNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 06:13:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44900 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab0AHLNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 06:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=slomS6MmeHmcqEILON/R2ZnP014sOpb56wugLtmtKaAcR+/KcZj8axGZ7wMyrbP+yQ
         fvjGZtr5vAZ6o0mTXla9m1TRoPkOxNwec2QwLrI1D2TF9/J4+VqVQUSTNtMwm215OKuz
         u25/VdEesOLH9BTHvIR8/8fSaSqgGLqfGHZMs=
Subject: Re: [PATCH 2/4] mfd: mc13783: When probing, unlock the mc13783
 before subsystems initialisation.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <1261349401.5224.154.camel@climbing-alby>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby>
	 <1260811085.2022.135.camel@climbing-alby>
	 <1261152746.3356.72.camel@climbing-alby>
	 <20091219201816.GA28742@pengutronix.de>
	 <1261316918.5224.15.camel@climbing-alby>
	 <20091220184941.GA13294@pengutronix.de>
	 <1261349401.5224.154.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 12:13:35 +0100
Message-ID: <1262949215.2050.19.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel, although patch [1/4] is not a matter of .33 
I think this one [2/4] can go to mainline in this subversion.

As submitted by Valentin Longchamp here:

http://thread.gmane.org/gmane.linux.ports.arm.kernel/71128/focus=71127

this patch, Acked by Uwe, fix a little regression in mc13783-core.

Best Regards,
Alberto!

