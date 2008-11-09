Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYKINVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYKINVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYKINVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:21:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYKINVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:21:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.28-rc3: regression, thinkpad x60 will not reboot
Date: Sun, 9 Nov 2008 14:26:24 +0100
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20081109123335.GA1783@elf.ucw.cz>
In-Reply-To: <20081109123335.GA1783@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091426.24888.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of November 2008, Pavel Machek wrote:
> Hi!
> 
> Subject says it pretty much all. No, I do not think I have KVM
> enabled:
> 
> CONFIG_HAVE_KVM=y
> 
> ...is the only KVM related option in my .config.
> 
> It seems 100% reproducible.

Can you check if
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8d00450d296dedec9ada38d43b83e79cca6fd5a3
helps, please?

Thanks,
Rafael
