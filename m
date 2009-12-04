Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZLDXTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZLDXTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZLDXTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:19:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60677
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbZLDXTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:19:34 -0500
Date: Fri, 04 Dec 2009 15:19:40 -0800 (PST)
Message-Id: <20091204.151940.64771804.davem@davemloft.net>
To: re.emese@gmail.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 22/31] Constify struct neigh_ops for 2.6.32 v1
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B199518.7090300@gmail.com>
References: <4B198670.2000406@gmail.com>
	<4B198FA1.7090807@gmail.com>
	<4B199518.7090300@gmail.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>
Date: Sat, 05 Dec 2009 00:02:48 +0100

> Added netdev@vger.kernel.org to CC.

It is better to make the proper patch posting again to
netdev, otherwise your patch will not get tracked and
watched over at patchwork.ozlabs.org
