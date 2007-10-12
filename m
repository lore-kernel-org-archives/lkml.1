Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbXJLTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbXJLTz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbXJLTzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:55:21 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:47759 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbXJLTzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:55:20 -0400
Date: Fri, 12 Oct 2007 21:55:13 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [GIT PULL] MMC updates
Message-ID: <20071012215513.1a4dfc7d@poseidon.drzeus.cx>
In-Reply-To: <alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
References: <20071010212149.0073ee08@poseidon.drzeus.cx>
	<alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 22:30:41 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> There seems to be some breakage here:
> 

Breakage repaired (and some new git voodoo learned. woot!). I even
threw in a few randconfig for good measure. So repull and things should
be peachy.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
