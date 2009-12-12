Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbZLMBga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbZLMBga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbZLMBg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:36:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57750 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933510AbZLMBg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cWwj1aaG7kH4pSLpUoBuJsjJBo5YCrbuXzlXQ4mQQXJT8rpZN7lTwSQjUijxwou1yH
         vQAcWYK77vXDJM2b7fMekIyJ4JImcdGsXTmVdky3DxtNgVTJ/GnfX9EN2A0ua8fSSXnN
         FYirvx4Z3tsfXetaF9sjgAJndVQBZP1Lguk1I=
Subject: [PATCH 0/4]  Patch series for introduce voltage selecting for
 mc13783 regulators.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 17:37:09 +0100
Message-ID: <1260635829.2054.16.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fix some problems in mfd mc13783 core driver
and extend mc13783-regulator driver with voltage selection capability.


First two patches apply to  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Last two patches apply to git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-next



