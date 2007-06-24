Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbXFXV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbXFXV3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXFXV3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:29:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbXFXV3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:29:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: Failure to properly reinit i8042 post suspend-to-ram
Date: Sun, 24 Jun 2007 23:03:20 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
References: <200706221607.33274.nigel@nigel.suspend2.net>
In-Reply-To: <200706221607.33274.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706242303.21065.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, 22 June 2007 08:07, Nigel Cunningham wrote:
> Hi.
> 
> I have recently begun to try and use suspend to ram more, and have an 
> intermittent problem. Actually, it's a couple of (possibly related) problems, 
> but I'll start with the one that's easiest.
> 
> Sometimes, when I resume, the keyboard stops responding. I then need to hold 
> down the power button for 4 seconds. At the next boot, things are still not 
> right. The i8042 controller seems to be confused about it's mode, because I 
> get the following differences in dmesg to a 'normal' boot:

Well, I'm afraid no one has any idea.

I think you can file a bug report with the kernel bugzilla.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
