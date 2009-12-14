Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZLNQl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZLNQl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZLNQlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:41:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64856 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbZLNQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:41:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RTdRCwfScFg0Bi4HdDqxpOMM5sIf6lRedQxlR8ht4Z9oUWH2/MYCFwXqHNhIukKC2R
         uIVnq4RzD63dop7KKCIofFKrB5cSs2HLAAPltQ28d6QAVBWv1s/qbCqJuLUFukWHEVPB
         W2NTRI34WyfdvPx4+lhScSU/VG+OtUBUIAX5g=
Subject: [PATCH 0/4 v2] Patch series for introduce voltage selecting for
 mc13783 regulators.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 17:41:20 +0100
Message-ID: <1260808880.2022.98.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend this series of patches.

This series of patches fix some problems in mfd mc13783 core driver
and extend mc13783-regulator driver with voltage selection capability.


First two patches apply to  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Last two patches apply to git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-next

