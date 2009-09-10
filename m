Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZIJShy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZIJShy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZIJShx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:37:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34093 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZIJShx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:37:53 -0400
Date: Thu, 10 Sep 2009 20:37:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] PM: Asynchronous suspend of devices
Message-ID: <20090910183750.GA23356@elf.ucw.cz>
References: <200909100127.11252.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909100127.11252.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> The following series of patches implements asynchronous suspend and resume of
> devices.
> 
> All of the patches have already been discussed, please refer to the changelogs
> for details.
> 
> The patches are targeted at 2.6.33, so if there are no major objections, I'll
> put them into the linux-next branch of the suspend-2.6 tree after .31-rc1 is
> out.

Patches 1-6 look mostly ok to me, I guess you can add my Acked-by. The
rest is fine, too, but I'm not sure if we really need so much of
debugging infrastructure...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
