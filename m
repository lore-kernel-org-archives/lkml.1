Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbXH2Tjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbXH2Tjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXH2Tjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:39:43 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56046
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbXH2Tjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:39:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
Date: Wed, 29 Aug 2007 21:37:48 +0200
User-Agent: KMail/1.9.6
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
References: <2713029743177393055@pripojeni.net> <20070829192858.75aa6542@the-village.bc.nu> <9e4733910708291233h3c4022a9n6e46733c5c50e222@mail.gmail.com>
In-Reply-To: <9e4733910708291233h3c4022a9n6e46733c5c50e222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708292137.48834.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007 21:33:43 Jon Smirl wrote:
> What if a patch spans both code that is pure GPL and code imported
> from BSD, how do you license it?

I think it's a valid assumption, if we say that the author
of the patch read the license header of a file and agreed with it.
So the patch is licensed to whatever the fileheader says. And if
there's none, it's licensed with the COPYING terms.
If a patch author likes some other license conditions, he must
explicitely add them with the patch to the file, saying that this
and that part have these and those conditions. Of course they must
be compatible with the original license.

-- 
Greetings Michael.
