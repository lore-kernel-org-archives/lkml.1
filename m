Return-Path: <linux-kernel-owner+w=401wt.eu-S1764672AbYCGTJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764672AbYCGTJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762175AbYCGTJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:09:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37978
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755605AbYCGTJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:09:22 -0500
Date: Fri, 07 Mar 2008 11:09:22 -0800 (PST)
Message-Id: <20080307.110922.16187211.davem@davemloft.net>
To: xemul@openvz.org
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] Make /proc/net a symlink on /proc/self/net (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <47D1462F.5060800@openvz.org>
References: <47D1462F.5060800@openvz.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>
Date: Fri, 07 Mar 2008 16:42:07 +0300

> Current /proc/net is done with so called "shadows", but current
> implementation is broken and has little chances to get fixed.
 ...

Applied, thanks Pavel.

I'm travelling so it might take a day or two for me to get this
to Linus.
