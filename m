Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0BNXIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:08:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60381 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab0BNXIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:08:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ronis@ronispc.chem.mcgill.ca
Subject: Re: Dell video dies when booting 2.26.32.[78].
Date: Mon, 15 Feb 2010 00:08:38 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <1266109622.11290.10.camel@montroll.chem.mcgill.ca>
In-Reply-To: <1266109622.11290.10.camel@montroll.chem.mcgill.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002150008.39044.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010, David Ronis wrote:
> I just upgraded the kernel on a 2.6.32.3 box to 2.6.32.8.   When I
> rebooted, I get the usual lilo prompt, and I select 2.6.32.8.  Things
> display properly for the first second or so of the boot, but then the
> screen goes blank (worse, the power light started blinking which means
> that the connection to the video card is dead).  The boot is still
> running.  This is a DELL running slackware 13.0.  It's probably not
> relevant, but even in 2.6.32.3 X messes up resetting the video mode when
> I exit (basically the fonts are too small).
> 
> I don't subscribe to this list and would appreciated a CC of any
> response.

I have created a Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15305
for your report.

Rafael
