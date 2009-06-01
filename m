Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZFAQRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZFAQRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZFAQRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:17:42 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:39907 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751818AbZFAQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:17:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sCIFoR73pxPkAgh9eO+gEN8aPr5AJcfltvjS1aGZjwVQhb6k4C3FvDG9QeAyVIUwoiSZLsX/lswJC1zDUW5e2yR03zPvw9ac5MuIcuIRpf67eMF2277dSncGTsameQaw;
Date: Mon, 1 Jun 2009 17:17:34 +0100
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joe Perches <joe@perches.com>
Cc: Jarod Wilson <jarod@redhat.com>, dri-devel@lists.sourceforge.net,
       xorg-devel@lists.x.org, linux-kernel@vger.kernel.org,
       Florian Demmer <florian@demmer.org>, eric@anholt.net
Subject: Re: [PATCH] drm: intel: add ignore lvds quirk info for AOpen Mini
 PC
Message-ID: <20090601171734.2b91fa37@jbarnes-x200>
In-Reply-To: <1243872701.3402.27.camel@Joe-Laptop.home>
References: <200905271720.40776.jarod@redhat.com>
	<20090601120126.550b2d15@jbarnes-x200>
	<200906011154.42177.jarod@redhat.com>
	<1243872701.3402.27.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 158.43.2.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Jun 2009 09:11:41 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2009-06-01 at 11:54 -0400, Jarod Wilson wrote:
> > On Monday 01 June 2009 07:01:26 Jesse Barnes wrote:
> > > Patches to the i915 driver should generally go
> > > to intel-gfx@lists.freedesktop.org so we don't miss them.  Thanks.
> 
> Does that apply to the i810 and i830 as well?

Those drivers are fairly abandoned afaik, so I'm not sure where patches
to them should go.  In fact I think i830 is deprecated in favor of
i915... so it should probably just be killed.

Jesse
