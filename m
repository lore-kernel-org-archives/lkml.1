Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZCJXEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZCJXEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZCJXE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:04:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46980 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbZCJXE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:04:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms" breaks resume from RAM on PowerBook
Date: Wed, 11 Mar 2009 00:04:03 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Gaudenz Steinlin <gaudenz@soziologie.ch>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090304083859.GB6889@soziologie.ch> <20090310213027.GB6272@soziologie.ch> <1236722866.7086.12.camel@pasglop>
In-Reply-To: <1236722866.7086.12.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903110004.04450.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 March 2009, Benjamin Herrenschmidt wrote:
> On Tue, 2009-03-10 at 22:30 +0100, Gaudenz Steinlin wrote:
> > Are you still interested in these tests after that disabling the early
> > resume hack fixed things? I can try my best to test and add printk's
> > but
> > it will probably take some time because I can't constantly reboot my
> > computer and still do some usefull work...
> > 
> No thanks, I think the initial test with early resume was flawed due to
> something like having cpufreq disabled.

Well, I've lost track a bit.

Which patch is going to be the final fix?

Rafael
