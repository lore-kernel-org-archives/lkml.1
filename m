Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbZLOQ3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbZLOQ3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760558AbZLOQ3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:29:42 -0500
Received: from senator.holtmann.net ([87.106.208.187]:60927 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760553AbZLOQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:29:39 -0500
Subject: Re: [PATCH] wireless: wext: allocate space for NULL-termination
 for 32byte SSIDs
From: Marcel Holtmann <marcel@holtmann.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
       Michael Hirsch <m.hirsch@raumfeld.com>, netdev@vger.kernel.org,
       libertas-dev@lists.infradead.org, stable@kernel.org
In-Reply-To: <1260650850-16163-1-git-send-email-daniel@caiaq.de>
References: <1260650850-16163-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 08:29:23 -0800
Message-Id: <1260894563.4041.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> We've experienced a long standing bug when quickly switching from
> ad-hoc to managed mode on a hardware using a Libertas chipset.

I don't know where you get your list of mailing lists from, but not
sending it to linux-wireless@vger.kernel.org will not really get you
anywhere. Check MAINTAINERS file first since it has all information
about it.

NETWORKING [WIRELESS]
M:      "John W. Linville" <linville@tuxdriver.com>
L:      linux-wireless@vger.kernel.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
S:      Maintained
F:      net/mac80211/
F:      net/rfkill/
F:      net/wireless/
F:      include/net/ieee80211*
F:      include/linux/wireless.h
F:      drivers/net/wireless/

Regards

Marcel


