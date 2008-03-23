Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbYCWHg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbYCWHg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 03:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYCWHgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 03:36:47 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:34767 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYCWHgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 03:36:46 -0400
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Subject: kernel panic, ip_route_input, 2.6.25-rc6-git2 (was lockdep... )
Date: Sun, 23 Mar 2008 09:36:38 +0200
Message-Id: <20080323073638.M89709@visp.net.lb>
X-Mailer: OpenWebMail 2.52 
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently tested, it crashes also -git6 without lockdep compiled. So it seems 
actually networking code bug.

--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

