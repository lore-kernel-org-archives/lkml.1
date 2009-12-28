Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbZL1HmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbZL1HmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZL1HmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:42:23 -0500
Received: from www84.your-server.de ([213.133.104.84]:34672 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZL1HmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:42:22 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227233816.GC2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	 <1261949800.25298.18.camel@wall-e>  <20091227233816.GC2399@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Dec 2009 08:42:16 +0100
Message-ID: <1261986136.808.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyway, I ack all your patches, expect the "2/6 Make kfifo_in atomic"
which will break my future work.

Stefani


