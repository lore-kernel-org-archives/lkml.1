Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbYBFEBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbYBFEBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 23:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbYBFEBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 23:01:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55339
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757526AbYBFEBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 23:01:38 -0500
Date: Tue, 05 Feb 2008 20:02:07 -0800 (PST)
Message-Id: <20080205.200207.107285204.davem@davemloft.net>
To: kyle@moffetthome.net
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [NET/IPv6] Race condition with flow_cache_genid?
From: David Miller <davem@davemloft.net>
In-Reply-To: <f73f7ab80802022128k2226b2f7r3c69ea1595073619@mail.gmail.com>
References: <f73f7ab80802022128k2226b2f7r3c69ea1595073619@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You'll get a better set of eyes on this if you post it
to netdev@vger.kernel.org which is where the networking
developers hang out.

linux-net is for user questions.
