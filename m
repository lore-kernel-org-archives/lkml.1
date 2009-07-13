Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbZGMVPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbZGMVPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbZGMVPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:15:04 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4006 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZGMVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:03 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/16] MAINTAINERS cleanups and get_maintainer.pl enhancements 
Date: Mon, 13 Jul 2009 14:14:46 -0700
Message-Id: <cover.1247517373.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A collection of cleanup patches to MAINTAINERS

scripts/get_maintainer.pl is improved a couple of ways.
  -f option allows git to return maintainers for directories
  --git-min-percent option allows cleanup style committers aren't maintainers

Joe Perches (16):
  MAINTAINERS: IA64 - pair P:/M: entries properly
  MAINTAINERS: Remove ivtv-user lists, add CX18 url
  MAINTAINERS: QLGE 10Gb ETHERNET - pair P:/M: entries properly
  MAINTAINERS: Use tabs in ACER ASPIRE ONE
  MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
  MAINTAINERS: Move ARPD to CREDITS
  MAINTAINERS: Update KERNEL JANITORS
  MAINTAINERS: Add PPS patterns
  MAINTAINERS: USB Serial Digi Acceleport: use separate P: for Al Borchers
  MAINTAINERS: INPUT: Add Dmitry's name to his email address
  MAINTAINERS: Remove CS461x sound card section
  MAINTAINERS: QLOGIC QLA2XXX - add Andrew Vasquez email address
  MAINTAINERS: QLOGIC QLA3XXX - Add Ron Mercer email address
  MAINTAINERS: Scott Murray is no longer with SomaNetworks
  scripts/get_maintainer.pl: Add -f directory use
  get_maintainer.pl: Add git-min-percent option

 CREDITS                   |    6 ++++
 MAINTAINERS               |   60 +++++++++++++++-----------------------------
 scripts/get_maintainer.pl |   42 ++++++++++++++++++++++++++-----
 3 files changed, 62 insertions(+), 46 deletions(-)

