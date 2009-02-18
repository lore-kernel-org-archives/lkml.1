Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZBRS13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZBRS13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZBRS1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:27:21 -0500
Received: from adsl134-239.ath.forthnet.gr ([79.103.101.239]:36917 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZBRS1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:27:21 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 13:27:20 EST
Message-ID: <499C50F2.4070203@asyr.hopto.org>
Date: Wed, 18 Feb 2009 20:18:26 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: cpu MHz in /proc/cpuinfo
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have overclocked a core 2 duo (E8400) from 3 to 4GHz using motherboard
BIOS settings. Although in windows I can see the overclocked frequency
(when cpu is under load), in linux /proc/cpuinfo never shows beyond the
stock 3GHz value. Is /proc/cpuinfo showing the actual frequency? Does
this mean my overclocking settings have no effect on linux?
