Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbXDFVi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbXDFVi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbXDFVi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:38:26 -0400
Received: from gw.goop.org ([64.81.55.164]:57493 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbXDFViZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:38:25 -0400
Message-ID: <4616BDA6.7090209@goop.org>
Date: Fri, 06 Apr 2007 14:37:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
 blinky leds!!)
References: <11757099691323-git-send-email-tony@atomide.com> <200704061029.55710.david-b@pacbell.net> <46169968.2050006@s5r6.in-berlin.de> <200704061405.50169.david-b@pacbell.net>
In-Reply-To: <200704061405.50169.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> Please change your coding style to conform to Documentation/CodingStyle.
>
> 	***	Only indent with tabs!!		***
>
> Every one of those examples violates that simple rule.
>   

Spaces are used to indent all over the kernel; using a few spaces to pad
out some indentation into the proper place is accepted practice,
regardless of what CodingStyle says.  The most important rule probably
needs to be explicitly added:

    Break any of these rules sooner than say anything outright barbarous.[1]

Though the first para of CodingStyle is very clear that it is a set of
guidelines rather than strict rules.

    J

1: http://www.k-1.com/Orwell/index.cgi/work/essays/language.html
