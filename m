Return-Path: <linux-kernel-owner+w=401wt.eu-S1161294AbXCNOwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161294AbXCNOwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161306AbXCNOwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:52:02 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:36118 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161294AbXCNOwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:52:00 -0400
Date: Wed, 14 Mar 2007 15:52:39 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Message-ID: <20070314145239.GK3802@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <20070313213842.GA23178@enneenne.com> <20070313224817.GF22466@csclub.uwaterloo.ca> <20070314093146.GE24556@enneenne.com> <20070314131934.GL22464@csclub.uwaterloo.ca> <20070314140623.GF3802@enneenne.com> <20070314141253.GM22464@csclub.uwaterloo.ca> <20070314142710.GJ3802@enneenne.com> <20070314144251.GN22464@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314144251.GN22464@csclub.uwaterloo.ca>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 10:42:51AM -0400, Lennart Sorensen wrote:
> 
> Now you said to check the return value of time_pps_readlink.  Well it

I refere to readlink(), not to time_pps_readlink(). I'm sorry for
mistake.

> If the call was to readlink directly it needs to be done, while your
> time_pps_readlink is just a handy wrapper that does all that for you,
> right?

Right.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
