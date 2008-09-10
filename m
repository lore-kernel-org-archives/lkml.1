Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYIJUXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYIJUXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYIJUW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:22:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56209
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbYIJUW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:22:58 -0400
Date: Wed, 10 Sep 2008 13:22:51 -0700 (PDT)
Message-Id: <20080910.132251.73509521.davem@davemloft.net>
To: ranjitm@google.com
Cc: kaber@trash.net, akpm@linux-foundation.org, lizf@cn.fujitsu.com,
       menage@google.com, tgraf@suug.ch, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] Traffic control cgroups subsystem
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0809101026190.7050@ranjit.corp.google.com>
References: <Pine.LNX.4.64.0809101026190.7050@ranjit.corp.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I definitely prefer Thomas Graf's work, this stuff is very ugly
and way overengineered.

So no, I won't consider for net-next-2.6, sorry.

