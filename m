Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYHUMo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYHUMo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbYHUMnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:43:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37227 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190AbYHUMnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:43:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Greaves <david@dgreaves.com>
Subject: Re: Regression? 2.6.27-rc3 segfault on cold boot; not on warm boot.
Date: Thu, 21 Aug 2008 14:47:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
References: <48AD3921.5090709@dgreaves.com>
In-Reply-To: <48AD3921.5090709@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211447.35284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, David Greaves wrote:
> I have a desktop system that has started having problems booting up in the morning.
> 
> It appears to just happen on more recent kernels.
> I was having unrelated CDROM problems with a driver in an old kernel and decided
> to test 2.6.27-rcX
> The CDROM problem is fine now.
> 
> However I started having problems on -rc1. I found that the machine was hanging
> soon after booting and needed a reboot. After a reboot it would work fine for
> the rest of the day.
> When -rc3 came out I tried that and the problem still appears to be there.
> 
> The normal process is now to boot to single-user, ctrl-alt-sysreq-SUB and then
> reboot to multi-user. This isn't ideal.
> 
> 
> If I cold boot 2.6.25.3 the problem doesn't occur.
> I will try different versions over the next few days.
> 
> Sample log from a few days back. (2.6.27-rc1 I think)
> 
> The problem does cause filesystem crashes so I'm cautious about messing around
> unguided.
> 
> Happy to try any suggestions.

Please try 2.6.26.x and see if the problem is present in there.

Thanks,
Rafael
