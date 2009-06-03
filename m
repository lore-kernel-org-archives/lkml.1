Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZFCW2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZFCW2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZFCW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:28:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:51306 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbZFCW2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:28:00 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jan Scholz <scholz@fias.uni-frankfurt.de>
In-Reply-To: <200906032210.54854.rjw@sisk.pl>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <1244018021.10665.4.camel@johannes.local> <200906031116.05114.rjw@sisk.pl>
	 <200906032210.54854.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 08:25:26 +1000
Message-Id: <1244067926.27194.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-03 at 22:10 +0200, Rafael J. Wysocki wrote:
> Apparently, we have two hibernation and suspend bugs on macbooks
> related to suspend_device_irqs() and resume_device_irqs(), the other
> one is
> (http://bugzilla.kernel.org/show_bug.cgi?id=13407) and I have no idea
> what's
> up.

The other one is a _powerbook_ bug, very different machine (powerpc
mac). macbooks are just almost ordinary x86 gear :-)

I'll try to tackle the trackpad problem.

Cheers,
Ben.


