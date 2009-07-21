Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZGUMws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZGUMws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZGUMwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:52:46 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:40908 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZGUMwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:52:46 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH 0/4] cpc-usb patches
Date: Tue, 21 Jul 2009 15:52:22 +0300
Message-Id: <1248180746-18140-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple comment convertion patches. more to come soon.

Felipe Balbi (4):
  staging: cpc-usb: convert comment style in cpc.h
  staging: cpc-usb: convert comment style in cpc_int.h
  staging: cpc-usb: convert comment style in cpcusb.h
  staging: cpc-usb: add one todo entry

 drivers/staging/cpc-usb/TODO      |    1 +
 drivers/staging/cpc-usb/cpc.h     |  504 +++++++++++++++++--------------------
 drivers/staging/cpc-usb/cpc_int.h |    8 +-
 drivers/staging/cpc-usb/cpcusb.h  |    2 +-
 4 files changed, 239 insertions(+), 276 deletions(-)

