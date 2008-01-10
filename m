Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbYAJRLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbYAJRLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYAJRLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:11:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52985 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbYAJRLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:11:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Date: Thu, 10 Jan 2008 18:14:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <ak@suse.de>, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20080103442.621670000@suse.de> <200801032241.29218.rjw@sisk.pl> <20080104092315.GL28740@elte.hu>
In-Reply-To: <20080104092315.GL28740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101814.11825.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for not replying earlier, I missed your message.]

On Friday, 4 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > So you would need to fix that first. Would be fine for me, but is 
> > > out of scope for my patch.
> > 
> > OK, I'll fix that up later.
> 
> i'll apply Andi's patch to x86.git - or would like to maintain that 
> patch?

x86.git would be fine.

Thanks,
Rafael
