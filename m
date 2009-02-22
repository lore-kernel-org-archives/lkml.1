Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZBVX1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZBVX1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZBVX1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:27:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35378 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbZBVX1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:27:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [RFC][PATCH] add mutex and hibernation notifier to memory hotplug.
Date: Mon, 23 Feb 2009 00:26:33 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       gerald.schaefer@de.ibm.com, ncunningham@crca.org.au,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Tolentino <matthew.e.tolentino@intel.com>, Hansen <haveblue@us.ibm.com>,
       linux-pm@lists.osdl.org, Matt@smtp1.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Dave@smtp1.linux-foundation.org, Mel Gorman <mel@skynet.ie>,
       Andy@smtp1.linux-foundation.org, Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20081106153444.33af7019.kamezawa.hiroyu@jp.fujitsu.com> <20090222223547.GH26999@elf.ucw.cz>
In-Reply-To: <20090222223547.GH26999@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902230026.35284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 February 2009, Pavel Machek wrote:
> Hi!
> 
> > Sorry, I can't test this now but I post this while discussion is hot.
> > 
> > I'll test this with CONFIG_PM_DEBUG's hibernation test mode if I can.
> > (But may take a long time..) 
> > 
> > Any feedback is welcome.
> 
> I lost the track here... but this may still be required... ? And given
> that there will be both mem hotplug and swsusp in SLE11...

I think the patch would be helpful, but I've lost it somethow.  I'll try to dig
it out in my e-mail archives.

Thanks,
Rafael
