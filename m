Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZDWNK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZDWNK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZDWNKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:10:45 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17564 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488AbZDWNKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:10:43 -0400
From: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
To: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Cc: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Subject: [PATCH 0/1] *** SUBJECT HERE ***
Date: Thu, 23 Apr 2009 16:10:07 +0300
Message-Id: <1240492208-14791-1-git-send-email-peter.de-schrijver@nokia.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 23 Apr 2009 13:10:10.0588 (UTC) FILETIME=[D4D4DDC0:01C9C414]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

Peter 'p2' De Schrijver (1):
  Activate VDD1, VDD2 and VPLL1 at startup

 drivers/regulator/twl4030-regulator.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

