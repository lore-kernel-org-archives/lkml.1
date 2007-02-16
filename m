Return-Path: <linux-kernel-owner+w=401wt.eu-S966198AbXBPIgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966198AbXBPIgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966205AbXBPIgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:36:12 -0500
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:54765 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966198AbXBPIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:36:11 -0500
Date: Fri, 16 Feb 2007 09:36:08 +0100
From: Martin Mares <mj@ucw.cz>
To: v j <vj.linux@gmail.com>
Cc: Scott Preece <sepreece@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <mj+md-20070216.082739.26560.nikam@ucw.cz>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070215165339.GB5285@thunk.org> <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com> <7b69d1470702151705h297c3b38g138eb0138b900aea@mail.gmail.com> <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Assuming these need not be GPL, I have a problem with
> EXPORT_SYMBOL_GPL and the general trend in the direction of making
> proprietary drivers harder on companies.

Most kernel developers did always say they don't agree with proprietary
drivers, don't want to support them and that they are convinced such
drivers are illegal. And according to the language of the GPL and the
copyright law, it's quite possible they really are illegal (although
a court _might_ rule that the modules are not a derived work of the
kernel). Even with all that, you still decided to distribute such
modules. What you are complaining about?

> So why beat about the bush? Just make it illegal to load proprietary
> drivers, or remove EXPORT_SYMBOL_GPL.

The point is that it's impossible to make it illegal (although many of
the authors of the kernel would like to) -- the point is that if kernel
modules aren't derivative works of the kernel, the kernel license cannot
control them.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
This mail doesn't contain viruses, because it wasn't sent from MS Windows. Checked by eyes.
