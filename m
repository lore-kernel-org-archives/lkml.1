Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYKCP1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYKCP1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbYKCP1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:27:08 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41894 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbYKCP1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:27:07 -0500
X-Sasl-enc: DJR1jaOoXVc1oNaPxW0Wr965NTThc6pRooMRqduzy19P 1225726025
Date: Mon, 3 Nov 2008 13:26:59 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: thinkpad_acpi: struct device - replace bus_id with dev_name(),
	dev_set_name()
Message-ID: <20081103152659.GG31078@khazad-dum.debian.net>
References: <1225330737.5970.96.camel@nga.site> <20081103145423.GE31078@khazad-dum.debian.net> <ac3eb2510811030714k55afc475h6edf3e97b8a50888@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510811030714k55afc475h6edf3e97b8a50888@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008, Kay Sievers wrote:
> On Mon, Nov 3, 2008 at 15:54, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Thu, 30 Oct 2008, Kay Sievers wrote:
> >> From: Kay Sievers <kay.sievers@vrfy.org>
> >> Subject: thinkpad_acpi: struct device - replace bus_id with dev_name(), dev_set_name()
> >>
> >> CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> >> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> >> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> >
> > Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> >
> > Do you want me to push it to Len for merge through the acpi tree, or are
> > you guys going to be handle it through another tree?
> 
> Would be nice if you can push it and it will show up in -next soon, so
> we can check there what's still missing.

I will push it to Len, but it depends on him when it will hit -next.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
