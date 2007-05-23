Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbXEWMvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbXEWMvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXEWMvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:51:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42548 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564AbXEWMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:51:06 -0400
X-Sasl-enc: YUrnHmKwWfE1yr1hOr3s3wOyj7hegHo5k+G1hzs6x+C2 1179924665
Date: Wed, 23 May 2007 09:51:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070523125100.GA826@khazad-dum.debian.net>
References: <20070519204504.GA24704@khazad-dum.debian.net> <20070519223843.GN11115@waste.org> <20070520035259.GA13224@khazad-dum.debian.net> <20070521222339.GF11115@waste.org> <20070521230349.GA645@khazad-dum.debian.net> <20070522224515.GW11115@waste.org> <20070523001943.GA3743@khazad-dum.debian.net> <20070523014825.GX11115@waste.org> <20070523041958.GA15952@khazad-dum.debian.net> <2c0942db0705222141se133553re06370476d436b12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0705222141se133553re06370476d436b12@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Ray Lee wrote:
> On 5/22/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> >> I shouldn't have to upgrade my BIOS to work with a new kernel any more
> >> than I should have to upgrade my browser.
> >
> >We don't agree there, as you are not talking about a stable kernel series.
> 
> Ah, so you're planning on submitting these patches for 2.7 then? 2.6
> is perpetually stable. Matt is quite correct; feel free to ask for
> clarifications from Linus et al if you need guidance.

2.6.x.y is stable.  2.6.x is not by any reasonably strict definition of
stable.  Unless you can explain how the stuff that went in 2.6.21 could be
added to a stable series kernel, do not even bother replying.

And for the record, the patches are NOT mine, but since I am the one usually
dealing directly with thinkpad firmware, I jumped in to help debug things as
a thinkpad firmware was *probably* to blame.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
