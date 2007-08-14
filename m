Return-Path: <linux-kernel-owner+w=401wt.eu-S935134AbXHNElA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134AbXHNElA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbXHNEkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:40:45 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4113 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbXHNEkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:40:43 -0400
Subject: Re: [PATCH] [154/2many] MAINTAINERS - DIGI INTL. EPCA DRIVER
From: Joe Perches <joe@perches.com>
To: Cal Peake <cp@absolutedigital.net>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Eng.Linux@digi.com
In-Reply-To: <Pine.LNX.4.64.0708140021460.11945@lancer.cnet.absolutedigital.net>
References: <46bff988.qGtTTlNorD2He7J3%joe@perches.com>
	 <20070813115344.04759b74@the-village.bc.nu>
	 <46C06E70.9090905@s5r6.in-berlin.de> <46C0838A.2030504@intel.com>
	 <1187022904.10249.97.camel@localhost> <1187064798.32555.7.camel@localhost>
	 <Pine.LNX.4.64.0708140021460.11945@lancer.cnet.absolutedigital.net>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 21:39:51 -0700
Message-Id: <1187066391.32555.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 00:29 -0400, Cal Peake wrote:
> Prolly /[^a-z0-9]/i would the safest bet. Also don't forget to escape 
> double quotes (e.g. "Jonathan \"Jon\" Doe" <jon@example.net>).

A-Z and [[:space:]] are OK too.
I skimmed the spec, but nothing jumped out at me.

