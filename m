Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbXKSTFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbXKSTFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXKSTFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:05:37 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43924
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXKSTFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:05:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [HIFN 00/03]: RNG support v2
Date: Mon, 19 Nov 2007 20:04:35 +0100
User-Agent: KMail/1.9.6
Cc: herbert@gondor.apana.org.au, johnpol@2ka.mipt.ru,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain> <200711191919.42466.mb@bu3sch.de> <4741D515.3050900@trash.net>
In-Reply-To: <4741D515.3050900@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711192004.35489.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 November 2007 19:25:25 Patrick McHardy wrote:
> Michael Buesch wrote:
> > On Sunday 18 November 2007 22:32:52 Patrick McHardy wrote:
> >> These patches add support for using the HIFN rng.
> > 
> > Acked-by: Michael Buesch <mb@bu3sch.de>
> > 
> > Patrick, can you send this patchset to Andrew for inclusion into -mm?
> 
> 
> I think he already pulls from Herbert's cryptodev-2.6 tree
> (otherwise the patches useless anyway since the HIFN driver
> is only in that tree).
> 
> 
> 

Ok, well. Then apply it to any tree you like and push it
upstream somehow. I'm OK with it.

-- 
Greetings Michael.
