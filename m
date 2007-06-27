Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbXF0CBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbXF0CBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbXF0CAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:00:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36696 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996AbXF0CAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:00:54 -0400
X-Sasl-enc: QVq7Hiz34XMjJDv0MyEExiMYupESFBh0XUXyxz8p9HMP 1182909653
Date: Tue, 26 Jun 2007 23:00:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-ID: <20070627020045.GA5491@khazad-dum.debian.net>
References: <200706241555.22957.mb@bu3sch.de> <20070626031340.GQ11166@waste.org> <20070626140624.GC30655@khazad-dum.debian.net> <200706261620.33898.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706261620.33898.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Michael Buesch wrote:
> On Tuesday 26 June 2007 16:06:25 Henrique de Moraes Holschuh wrote:
> > Which, AFAIK, we can quantify as the minimum expected entropy in the output.
> 
> The category is _not_ a measure of the entropy in the output.
> It is _just_ to get the chance to get a sane _default_ policy
> for which RNG is enabled by default, in the kernel.
> It's just about a default policy. _Nothing_ else.

Then why don't you call it "preference", or something to that effect?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
