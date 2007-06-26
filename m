Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbXFZOVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbXFZOVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXFZOVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:21:12 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48306
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbXFZOVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:21:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] hw_random: add quality categories
Date: Tue, 26 Jun 2007 16:20:33 +0200
User-Agent: KMail/1.9.6
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706241555.22957.mb@bu3sch.de> <20070626031340.GQ11166@waste.org> <20070626140624.GC30655@khazad-dum.debian.net>
In-Reply-To: <20070626140624.GC30655@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261620.33898.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 16:06:25 Henrique de Moraes Holschuh wrote:
> Which, AFAIK, we can quantify as the minimum expected entropy in the output.

The category is _not_ a measure of the entropy in the output.
It is _just_ to get the chance to get a sane _default_ policy
for which RNG is enabled by default, in the kernel.
It's just about a default policy. _Nothing_ else.

-- 
Greetings Michael.
