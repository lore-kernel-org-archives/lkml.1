Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbXLNMKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbXLNMKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXLNMKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:10:36 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:39360 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbXLNMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:10:36 -0500
Subject: Re: Print taint info in more places.
From: Jon Masters <jonathan@jonmasters.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071213224927.GA18639@redhat.com>
References: <20071213224927.GA18639@redhat.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 14 Dec 2007 07:09:59 -0500
Message-Id: <1197634200.29507.98.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 17:49 -0500, Dave Jones wrote:
> We've found in the past that various bug reports have had minimal
> information, just a few printk's rather than a complete oops,
> and it's taken several round-trips with the bug reporter before
> we've discovered they had some proprietary module loaded.
> 
> The patches below adds dumping of the tainted state to some
> extra parts of the kernel that report 'bad things' happening.
> These patches have been in the Fedora kernel for some time now,
> and have proved useful often.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

In my opinion, this is a very good idea :-)

Jon.


