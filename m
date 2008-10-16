Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYJPTd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYJPTd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYJPTc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:32:57 -0400
Received: from www17.your-server.de ([213.133.104.17]:48184 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYJPTc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:32:56 -0400
X-Greylist: delayed 1447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2008 15:32:56 EDT
Subject: New warnings in dmesg with v2.6.27-4431-g04ab591
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 21:09:53 +0200
Message-Id: <1224184193.3836.3.camel@dhcppc2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting with option quiet gives these new warnings compared to 2.6.27:

[    0.142007] cfg80211: Calling CRDA to update world regulatory domain
[    0.142009] cfg80211: Failed calling CRDA
[    0.142019] cfg80211: calling CRDA failed - unable to update world regulatory domain, using static definition

[    0.348823] alg: cipher: Test 1 failed on encryption for aes-asm

Should i care?

greets
thomas


