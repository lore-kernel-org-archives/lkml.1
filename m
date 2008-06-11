Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbYFKQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbYFKQNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYFKQNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:13:07 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:55620 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753526AbYFKQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:13:06 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: [regression?] Sometime (often) X come out blank (black screen) on cold boot - Intel chipset
Date: Wed, 11 Jun 2008 09:12:59 -0700
User-Agent: KMail/1.9.9
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Justin Madru <jdm64@gawab.com>
References: <1213101501.21041.9.camel@pern> <200806101106.23899.jbarnes@virtuousgeek.org> <1213160635.9453.15.camel@localhost>
In-Reply-To: <1213160635.9453.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806110912.59819.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2008 10:03 pm Romano Giannetti wrote:
> On Tue, 2008-06-10 at 11:06 -0700, Jesse Barnes wrote:
> > On Tuesday, June 10, 2008 5:38 am Romano Giannetti wrote:
> >
> > This sounds like a DUP; I remember Justin Madru had a similar issue (with
> > Ubuntu & gdm even iirc).
> >
> > Is there any way you could run the latest git bits of the Intel X driver?
> > I've added some debugging that could catch at least one of the common
> > reasons why the display would blank like that...
>
> Yes, I think I can. Please give me instructions... I have a git
> repository tracking Linus' one.
>
> BTW, maybe I'm on dope, but thinking hard, it seems to me that the blank
> screen happens nly when I cold reboot after a crash forced me to
> poweroff abruptly the laptop. Last time happened after a battery runoff.
> It's that possible?
>
> Moreover, I see a lot of flashing on shutdown (I'm sure I've seen a
> report like that, but I am unable to dig it out now)...

Check out http://www.intellinuxgraphics.org/ for instructions on building the 
driver.  You may also want to check out Freedesktop bug 15602 which Justin 
filed upstream (https://bugs.freedesktop.org/show_bug.cgi?id=15602).

Thanks,
Jesse
