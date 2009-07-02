Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZGBWcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZGBWcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZGBWcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:32:45 -0400
Received: from drutsystem.com ([80.72.38.138]:3978 "EHLO drutsystem.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZGBWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:32:44 -0400
X-Greylist: delayed 1911 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 18:32:44 EDT
Message-ID: <4A4D2E11.4020707@ziu.info>
Date: Fri, 03 Jul 2009 00:00:49 +0200
From: Michal Soltys <soltys@ziu.info>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
References: <200906280821.58631.info@gnebu.es> <200907020818.58541.info@gnebu.es> <20090702093547.7ca95116@jbarnes-g45> <200907022137.27847.info@gnebu.es>
In-Reply-To: <200907022137.27847.info@gnebu.es>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV on drutsystem.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding Arch's default distro kernel - it's a bit patched. Most of the 
patch file is addition of aufs, but there're other diffs included as 
well, some of them modifying i915_reg.h, intel_display.c and intel_tv.c

ftp://ftp.archlinux.org/other/kernel26/patch-2.6.30-5-ARCH.bz2

Not sure how relevant that is, but fyi.
