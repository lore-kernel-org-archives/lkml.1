Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYDWXFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYDWXFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYDWXFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:05:39 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:35917 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYDWXFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:05:38 -0400
X-Greylist: delayed 770 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2008 19:05:38 EDT
X-ClientAddr: 220.233.82.121
Subject: Re: Microblaze Linux release
From: John Williams <john.williams@petalogix.com>
To: monstr@seznam.cz
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       Arnd Bergmann <arnd@arndb.de>, Paul Mackerras <paulus@samba.org>,
       benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       jwboyer@linux.vnet.ibm.com, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <480FA8A4.7020207@seznam.cz>
References: <48020A21.4000404@seznam.cz> <200804161733.04714.arnd@arndb.de>
	 <480FA235.8000203@seznam.cz>
	 <200804232257.04060.florian.fainelli@telecomint.eu>
	 <480FA8A4.7020207@seznam.cz>
Content-Type: text/plain
Organization: PetaLogix
Date: Thu, 24 Apr 2008 08:51:17 +1000
Message-Id: <1208991077.3050.141.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2008-04-23 at 23:22 +0200, Michal Simek wrote:
> > Hi Michal
> > 
> >> Hi all,
> >>
> >> I update Microblaze kernel to latest Linus tree. I fixed some problems
> >> which come with it.
> > 
> > While reading the previous discussion, I wondered that keeping PCI would be a 
> > good idea. I am personnaly using it for a custom design and would be glad 
> > being able to continue using it.
> 
> I'll add PCI parts as I will have a reason to do it. I have no PCI devices
> connected to MB now.
> 
> > If this represents too much work for you, we can probably add it later.
> 
> yes. This is lot of work for me unfortunately without any commercial support.
> 
> > Great work !

I have a working PCI implementation that I will submit once Michal's
patches are finalised.

Unsurprisingly it is heavily derived from the PPC implementation, but
reworked a little bit.

Regards,

John

> 
> Have a good day,
> Michal Simek
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663


