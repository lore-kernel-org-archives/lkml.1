Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbZIJSnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbZIJSnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZIJSnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:43:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbZIJSnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:43:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/9] PM: Asynchronous suspend of devices
Date: Thu, 10 Sep 2009 20:43:56 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <200909100127.11252.rjw@sisk.pl> <20090910183750.GA23356@elf.ucw.cz>
In-Reply-To: <20090910183750.GA23356@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909102043.56993.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 September 2009, Pavel Machek wrote:
> Hi!
> > 
> > The following series of patches implements asynchronous suspend and resume of
> > devices.
> > 
> > All of the patches have already been discussed, please refer to the changelogs
> > for details.
> > 
> > The patches are targeted at 2.6.33, so if there are no major objections, I'll
> > put them into the linux-next branch of the suspend-2.6 tree after .31-rc1 is
> > out.
> 
> Patches 1-6 look mostly ok to me, I guess you can add my Acked-by.

Thanks!

> The rest is fine, too, but I'm not sure if we really need so much of
> debugging infrastructure...

I believe it will be useful.

Thanks,
Rafael
