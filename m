Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZGLU4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZGLU4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZGLUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:55:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbZGLUzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:55:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Celejar <celejar@gmail.com>
Subject: Re: suspend to disk now broken
Date: Sun, 12 Jul 2009 22:56:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20090712151947.25446ceb.celejar@gmail.com> <200907122219.53116.rjw@sisk.pl> <20090712162635.0e451001.celejar@gmail.com>
In-Reply-To: <20090712162635.0e451001.celejar@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907122256.01663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Celejar wrote:
> On Sun, 12 Jul 2009 22:19:52 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday 12 July 2009, Celejar wrote:
> > > Hi,
> > > 
> > > A recent change to the kernel has apparently broken suspend to disk on
> > > my machine.  It still works fine in 2.6.30.1, but hangs during the
> > > 'devices' phase of suspension with 2.6.31-rc2.  [I originally saw the
> 
> ...
> 
> > Do you use s2disk or 'echo disk > /sys/power/state'?
> 
> First 'hibernate', then 's2disk', and finally 'echo ...' :)  None work.

Please try to boot with init=/bin/bash and use the 'echo ...' method.

Rafael
