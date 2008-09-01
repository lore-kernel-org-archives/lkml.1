Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYIAVbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYIAVbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 17:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYIAVay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 17:30:54 -0400
Received: from www.tglx.de ([62.245.132.106]:53851 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYIAVax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 17:30:53 -0400
Date: Mon, 1 Sep 2008 23:30:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809012323090.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Thomas Gleixner wrote:
> 
> I'm happy to discard the PIT on the 32bit machines again and then file

ooops ---------------------^^^ wanted to say PMTIMER of course :)

      tglx
