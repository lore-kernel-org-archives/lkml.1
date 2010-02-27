Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966146Ab0B0LcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 06:32:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58168
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965891Ab0B0LcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 06:32:12 -0500
Date: Sat, 27 Feb 2010 03:32:30 -0800 (PST)
Message-Id: <20100227.033230.196838696.davem@davemloft.net>
To: opurdila@ixiacom.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       nhorman@tuxdriver.com, eric.dumazet@gmail.com, ebiederm@xmission.com,
       amwang@redhat.com
Subject: Re: [net-next PATCH v6 0/3] net: reserve ports for applications
 using fixed port numbers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267233952-5856-1-git-send-email-opurdila@ixiacom.com>
References: <1267233952-5856-1-git-send-email-opurdila@ixiacom.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eric B., could you look over the first two patches (which touch the
sysctl core) and give some review and ACK/NACK?

Thanks!
