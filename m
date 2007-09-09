Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbXIILX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbXIILX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 07:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXIILXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 07:23:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbXIILXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 07:23:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maciek Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Sun, 9 Sep 2007 13:35:02 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?iso-8859-2?q?Micha=B3_sed?= <sedmich@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, htejun@gmail.com, hmh@hmh.eng.br,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <200709082329.57811.rjw@sisk.pl> <46E3BAD1.4080709@gmail.com>
In-Reply-To: <46E3BAD1.4080709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709091335.03330.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 September 2007 11:20, Maciek Rutecki wrote:
> Rafael J. Wysocki pisze:
> >> Shutdown is completely broken on HP NX6??? laptops.
> > 
> > It's not completely broken, it just handles disks incorrectly and we are not
> > sure whether or not there are any serious consequences of that.  Moreover,
> > it has happened for a long time now, AFAICT, so that's not a regression.
> 
> Maybe it isn't regression, we can call it no matter how, but this issue
> can shorten disk live.

Well, I'll try to carry out some experiments with it later today ...
