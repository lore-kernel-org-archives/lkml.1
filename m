Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYLMNgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYLMNgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 08:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbYLMNgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 08:36:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40043 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbYLMNgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 08:36:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Bugs on aspire one A150
Date: Sat, 13 Dec 2008 14:35:33 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, alsa-devel@alsa-project.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <491506DB.1070000@gmail.com> <1229174138.24940.9.camel@maxim-laptop>
In-Reply-To: <1229174138.24940.9.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812131435.34072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 of December 2008, Maxim Levitsky wrote:
> 
> So, big thanks for everything.
> 
> Now aspire one linux support is very close to perfect,
> (only problem left is that wireless is limited to 18Mbits/s raw rate,
> but at some point I or developers of ath5k will get to the bottom of
> this)
> 
> I also noticed, that now the SD only card reader is always enabled
> regardless of card been there while booting, and same happens in
> windows, I suspect that this is permanent hardware change, which worries
> me, but this reader works fine otherwise.
> (This is another reason why binary bioses are evil, go and find out why
> it enables it)
> 
> 
> Also forgot to mention that both readers ignore write protect tab on SD
> card, and I will report this to correct mailing list soon.
> Everything else works fine
> 
> please include acpiphp fix in 2.6.28.

Which one is this?

Rafael
