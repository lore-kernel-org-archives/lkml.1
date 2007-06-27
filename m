Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbXF0M7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbXF0M7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbXF0M7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:59:30 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43538
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbXF0M73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:59:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] hw_random: add quality categories
Date: Wed, 27 Jun 2007 14:58:51 +0200
User-Agent: KMail/1.9.6
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706241555.22957.mb@bu3sch.de> <200706261620.33898.mb@bu3sch.de> <20070627020045.GA5491@khazad-dum.debian.net>
In-Reply-To: <20070627020045.GA5491@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271458.51884.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 04:00:46 Henrique de Moraes Holschuh wrote:
> On Tue, 26 Jun 2007, Michael Buesch wrote:
> > On Tuesday 26 June 2007 16:06:25 Henrique de Moraes Holschuh wrote:
> > > Which, AFAIK, we can quantify as the minimum expected entropy in the output.
> > 
> > The category is _not_ a measure of the entropy in the output.
> > It is _just_ to get the chance to get a sane _default_ policy
> > for which RNG is enabled by default, in the kernel.
> > It's just about a default policy. _Nothing_ else.
> 
> Then why don't you call it "preference", or something to that effect?

Why? Because I did not get the same idea as you?
So, please make up "preference" categories and give me some examples.

-- 
Greetings Michael.
