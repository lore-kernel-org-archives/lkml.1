Return-Path: <linux-kernel-owner+w=401wt.eu-S940054AbXHIN3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940054AbXHIN3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939231AbXHIN32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:29:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:59217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939203AbXHIN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:29:27 -0400
Date: Thu, 9 Aug 2007 15:29:18 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Bodo Eggert <7eggert@gmx.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
In-Reply-To: <Pine.LNX.4.64.0708091439270.10387@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.58.0708091508330.3273@be1.lrz>
References: <8QdB3-87O-7@gated-at.bofh.it> <8QdUr-5j-11@gated-at.bofh.it>
 <E1IJ7DO-0000pI-JN@be1.lrz> <Pine.LNX.4.64.0708091439270.10387@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+54SsQ7j9uPApOlqXXT2ryycixcKu4KjAHB0e
 iRKfh7gCRbfjKjspeMlZ3bWbcYmk21TuxKJVxQVZ0FomdPJqzk
 y1SvK9OKzzlTfWbXMtogg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Jan Engelhardt wrote:
> On Aug 9 2007 14:34, Bodo Eggert wrote:

> >I don't think <b> and <i> should be used, instead you should use styles
> >(<span class="code"> etc).
> 
> <b> does the same as <span style="font-weight: bold;">, and the latter is much
> more verbose for the same thing.

You shoud use neither. It's OK on homepages, but for documents, you should
be able to change the formating using stylesheet.

> >Things like <em> and <strong> should be OK, if used consistently.
> >
> >> Perhaps maybe <p class="block"> with .block{text-align:justify;}
> >> because that looks nice in general.
> >
> >If you like that, you can say "p {text-align:justify;}" in the default
> >stylesheet. (And if people would override the alignment, class="block"
> >would be the wrong name).
> 
> Oh that comes because MS Office calls it "Blocksatz" in German ;-)

I missed that point. What I wanted to say was: If the user overrides 
":justify", it would still be called "justified", which would be not 
justified.-)
-- 
"A slipping gear could let your M203 grenade launcher fire when you
least expect it. That would make you quite unpopular in what's left of
your unit."
-Army's magazine of preventive maintenance.
