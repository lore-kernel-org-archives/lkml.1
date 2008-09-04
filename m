Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYIDLcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYIDLcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYIDLcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:32:45 -0400
Received: from bu3sch.de ([62.75.166.246]:54287 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYIDLcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:32:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-kernel@vger.kernel.org
Subject: Who removed b43's QoS default parameters?
Date: Thu, 4 Sep 2008 13:32:19 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809041332.19170.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b43 had a mechanism to set default QoS parameters. Somebody
removed it, because changes in mac80211 introduced compiler
warnings for it.
A Bug was introduced. Does somebody know which patch removed that
stuff, so I don't have to dig git history?

-- 
Greetings Michael.
