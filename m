Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbYESUu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbYESUu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760863AbYESUua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:50:30 -0400
Received: from mx1.riseup.net ([204.13.164.18]:47506 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760604AbYESUu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:50:29 -0400
Message-Id: <20080519204838.612046856@kaehlcke.net>
User-Agent: quilt/0.46-1
Date: Mon, 19 May 2008 22:48:38 +0200
From: matthias@kaehlcke.net
To: khali@linux-fr.org, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/2] i2c-core.c: use list_for_each_entry_safe()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c-core.c: use list_for_each_entry_safe() in i2c_del_adapter() and i2c_del_driver()

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
