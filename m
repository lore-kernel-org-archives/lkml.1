Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZBJI7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZBJI7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZBJI73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:59:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40380
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbZBJI72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:59:28 -0500
Date: Tue, 10 Feb 2009 00:59:22 -0800 (PST)
Message-Id: <20090210.005922.117696811.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: roel.kluin@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevice: ticks reaches 25, not 26.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090210085021.GB4190@ff.dom.local>
References: <20090209.175714.70463534.davem@davemloft.net>
	<20090210085021.GB4190@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Tue, 10 Feb 2009 08:50:21 +0000

> So, what other C feature do you find a better source of joy now?

None really, that's why most of my own patches lately have been
doing nothing but remove code :-)
