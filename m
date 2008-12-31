Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYLaJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYLaJTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYLaJSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:18:47 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47786 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYLaJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:18:46 -0500
Date: Wed, 31 Dec 2008 10:18:45 +0100
From: Andreas Mohr <andi@lisas.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20081231091845.GA2516@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230641016.5770.5.camel@maxim-laptop>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Sure, will test, I am also sure that this will work.

A110L, 2.6.28, success (also inverted here, traffic blanks it).

Note that CONFIG_LEDS_TRIGGER_DEFAULT_ON=m, might be related
(possibly ath5k is just mis-using LEDs API, in light of this setting?).

Thanks a lot!

Andreas Mohr
