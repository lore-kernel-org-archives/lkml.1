Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYLZVUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYLZVUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYLZVUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:20:04 -0500
Received: from mx0.towertech.it ([213.215.222.73]:59162 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752326AbYLZVUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:20:03 -0500
X-Greylist: delayed 819 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Dec 2008 16:20:03 EST
Date: Fri, 26 Dec 2008 22:06:21 +0100
From: Alessandro Zummo <azummo-lists@towertech.it>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-geode@lists.infradead.org
Subject: Re: [PATCH] AMD Geode CS553X GPIO driver
Message-ID: <20081226220621.32469d7c@i1501.lan.towertech.it>
In-Reply-To: <200812261120.28834.david-b@pacbell.net>
References: <20081224234321.0890274e@i1501.lan.towertech.it>
 <200812261024.07303.david-b@pacbell.net>
 <20081226193854.41cbee89@i1501.lan.towertech.it>
 <200812261120.28834.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008 11:20:28 -0800
David Brownell <david-b@pacbell.net> wrote:


> some kind of scheduled flag day.  (Plus completing kernel
> infrastructure, of which NTP support is probably the most
> significant missing part right now.)

 almost completed it, need a few tests. suddenly all the people that
 were interested disappeared :)


> If you add this to the geode_32.c file it'll just provide a
> standard interfaces, which can coexist with the older stuff
> until it's removed.  Several of the ARM platforms have
> exactly that kind of coexistence going on.  (Example, OMAP;
> which in 2.6.29 will stops using its legacy GPIO calls.)

 ok, I'll seek some advice from the geode people. 


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

