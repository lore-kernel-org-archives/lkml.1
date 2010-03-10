Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0CJSca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:32:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59127 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab0CJSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:32:29 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B97E5B0.5070900@s5r6.in-berlin.de>
Date: Wed, 10 Mar 2010 19:32:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       devel <devel@driverdev.osuosl.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: Tuxradar patching article and [PATCH] scripts/cvt_kernel_style.pl
References: <1268177526.1545.62.camel@Joe-Laptop.home>
In-Reply-To: <1268177526.1545.62.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> There was an article published recently:
> http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel
> that seems to have prompted several new contributors (welcome)
> to create style reformatting patches.

Uh oh.  How can a newcomer know what good style is?

Please start your career of kernel contributions differently:
  - Test new kernels.  Report issues and work with the developers to
    get the issues fixed.
  - If there is a bug which nags you but there doesn't seem to be
    an active developer to fix it anytime soon, try to fix it yourself.

Or if you are aware of a small RFE for a subsystem which interests you
personally, try to implement that small feature.

It doesn't make sense to start kernel development with something which
you are likely not going to connect with personally.  (Reformat others'
code?  Better write your own code, i.e. a bug fix or a small feature.)

PS:
I am also saying this because I repeatedly see "style fixes" posted
which are questionable at best, or actually degrade style, or even
introduce bugs.

PPS:
How can a script know what good style is?
-- 
Stefan Richter
-=====-==-=- --== -=-=-
http://arcgraph.de/sr/
