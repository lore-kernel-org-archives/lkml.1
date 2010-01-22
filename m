Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691Ab0AVBRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0AVBRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628Ab0AVBRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:17:47 -0500
Received: from trinity.fluff.org ([89.16.178.74]:55370 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab0AVBQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:46 -0500
Date: Fri, 22 Jan 2010 01:16:43 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: torvalds@linux-foundtion.org, linux-arm-kernel@lists.infradead.org,
       Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PULL] Please pull bjdooks' for-linus/samsung
Message-ID: <20100122011642.GJ26562@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fix for the HMT machine's backlight code

The following changes since commit 3ce2f76f5dfeeacd128db9e5cd6945bac0ea0b2a:
  Ben Dooks (1):
        ARM: MINI2440: Fixup __initdata usage

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-linus/samsung

Peter Korsgaard (1):
      hmt: adjust for new pwm_backlight->notify prototype

 arch/arm/mach-s3c6410/mach-hmt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.
