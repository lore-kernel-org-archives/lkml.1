Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYD0JZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYD0JZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 05:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYD0JZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 05:25:09 -0400
Received: from ns.store20.com ([212.7.7.16]:41886 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbYD0JZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 05:25:08 -0400
Subject: [REGRESSION] Trouble seeing some wireless networks in latest git
From: Priit Laes <plaes@plaes.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 27 Apr 2008 12:24:58 +0300
Message-Id: <1209288298.3851.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

There seems to be some kind of regression in wireless drivers that makes
it not possible to see some wireless networks.

This can be seen with both b43 and iwl3945 drivers.

Using Kismet wireless scanner these networks were visible under latest
git.
All the networks rendered invisible seem to be from channels: 1 (one
network visible), 3, 8, 12 and 13. Visible networks are in channels 1,
4, 6, 9 and 11.

Any hints how to debug this further?

--
Priit
