Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbXDNUfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXDNUfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 16:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXDNUfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 16:35:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXDNUfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 16:35:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux 2.6.21-rc6
Date: Sat, 14 Apr 2007 22:38:43 +0200
User-Agent: KMail/1.9.5
Cc: Tobias Diedrich <ranma@tdiedrich.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704142223.32410.rjw@sisk.pl> <20070414202527.GH3691@stusta.de>
In-Reply-To: <20070414202527.GH3691@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704142238.44184.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 April 2007 22:25, Adrian Bunk wrote:
> On Sat, Apr 14, 2007 at 10:23:31PM +0200, Rafael J. Wysocki wrote:
> >...
> > Also, would that be feasible for you to use 'shutdown' as a workaround in case
> > the source of the problem is difficult to find and/or fix?
> 
> One person reporting a regression against a -rc kernel can mean
> houndreds or thousands of people who will run into the same issue after 
> 2.6.21 got released if a manual workaround is required...

Well, in this particular case it is not very likely to happen.  I have three
x86_64 machines here with totally different chipsets/devices on which I'm
not seeing anything like that and I believe we'd have more reports before
if that were a common issue.

That said, I'm not going to ignore it.  I'll do my best to debug and fix it, if
Tobias helps me. :-)

Greetings,
Rafael
