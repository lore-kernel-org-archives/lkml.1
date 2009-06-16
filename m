Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbZFPQTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbZFPQTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZFPQTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:19:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50575 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbZFPQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:19:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A37C602.4050104@s5r6.in-berlin.de>
Date: Tue, 16 Jun 2009 18:19:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>, Greg KH <greg@kroah.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge
 window
References: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com> <20090615201934.GA12685@kroah.com> <20090615214735.GE23972@bombadil.infradead.org> <20090615223206.GA4966@kroah.com> <20090616004122.GC5492@tesla> <20090616021011.GF23972@bombadil.infradead.org> <20090616032034.GA17932@kroah.com> <20090616042113.GA5680@tesla> <20090616093401.GA11602@jm.kir.nu>
In-Reply-To: <20090616093401.GA11602@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jouni Malinen wrote:
> If it
> weren't now allowed in during the rc-phase, it may not go into a stable
> release either (assuming the rc/stable rules are more or less the same)

They aren't.

Just compare shortlogs between -RCs with shortlogs between .Ys and 
everything becomes almost obvious.  :-)
-- 
Stefan Richter
-=====-==--= -==- =----
http://arcgraph.de/sr/
