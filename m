Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZD0Ur5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZD0Ur5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbZD0Urr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:47:47 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34624 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbZD0Urq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:47:46 -0400
Date: Mon, 27 Apr 2009 16:46:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: how to properly post/disseminate kernel cleanup/janitorial
 possibilities?
Message-ID: <alpine.LFD.2.00.0904271637470.4906@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  since i, on an occasional basis, run a set of scanning scripts i
wrote and promptly annoy the crap out of everyone with the results,
i'm open to the proper way to do this scanning and get the results out
there to people who might be interested while not bugging those folks
who aren't.

  a while back, a few people suggested a wiki page, while others
disagreed, suggesting that no one will follow a link to a wiki page
and will only read what's directly on the list.  grapple, grapple.

  in the end (as i'm sure you're aware by now), i post the results
here:

  http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup

i'm convinced that there's value in the links i've promoted lately --
scanning Kconfig files for unused or "bad" CONFIG variables, not just
to clean historical cruft out of those files but because, on occasion,
the scanning really does track down typoes and errors.

  not quite so critical is a "style" script i wrote, which looks for
places to simplify code by using some of the macros/functions defined
in include/linux/kernel.h.  i ran that script again earlier today, and
posted only *some* of the results here:

  http://www.crashcourse.ca/wiki/index.php/The_style_script

long story short, i have a *pile* of scripts and sub-scripts i'm happy
to run and post the results of since it takes practically zero time on
my part, i'm just open to what folks think is the most productive way
to do that, and also for any other scanning i can add since, by now,
any other patterns to scan for would just represent adding a line or
two to a script.

 thoughts?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
