Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZLDWZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZLDWZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZLDWZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:25:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35162
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396AbZLDWZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:25:47 -0500
Date: Fri, 04 Dec 2009 14:25:54 -0800 (PST)
Message-Id: <20091204.142554.246408242.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chunkeey@googlemail.com,
       reinette.chatre@intel.com
Subject: Re: [PATCH] mac80211: fix reorder buffer release
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091204215555.GC3595@tuxdriver.com>
References: <20091204215555.GC3595@tuxdriver.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 4 Dec 2009 16:55:55 -0500

> I missed this in today's pull request -- please queue it directly in
> your tree!

Applied.
