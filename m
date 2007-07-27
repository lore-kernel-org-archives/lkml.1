Return-Path: <linux-kernel-owner+w=401wt.eu-S935923AbXG0LRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923AbXG0LRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbXG0LRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:17:32 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2112 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbXG0LRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:17:31 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 07:17:26 EDT
Date: Fri, 27 Jul 2007 13:09:27 +0200
From: thunder7@xs4all.nl
To: Paulo da Silva <psdasilva@esoterica.pt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB subsystem (part of it) hangs
Message-ID: <20070727110927.GA20862@amd64.of.nowhere>
References: <46A94543.9050105@esoterica.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A94543.9050105@esoterica.pt>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paulo da Silva <psdasilva@esoterica.pt>
Date: Fri, Jul 27, 2007 at 02:07:15AM +0100
> This is a bug report. Any further information you may need, please let
> me know.
> Modules Loaded         ndiswrapper

problem is, once you load ndiswrapper + the proprietary, closed source
windows drivers that go with that, nobody here can tell you what's going
wrong, since nobody here can know what goes on inside that driver.

So unless you can reproduce it without ndiswrapper, it can't be solved.

Kind regards,
Jurriaan
-- 
..and the great tagline hunter crouches silently, text editor at the ready..
Debian (Unstable) GNU/Linux 2.6.22-rc6 2x2010 bogomips load 0.07
the Jack Vance Integral Edition: http://www.integralarchive.org
