Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbXGJQnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbXGJQnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbXGJQn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:43:27 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:48994 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbXGJQn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:43:26 -0400
Date: Tue, 10 Jul 2007 18:44:30 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070710164428.GJ32503@enneenne.com>
References: <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <20070701171325.29d8b184.sfr@canb.auug.org.au> <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca> <20070710163625.GH32503@enneenne.com> <1184085376.32628.18.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184085376.32628.18.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 05:36:16PM +0100, David Woodhouse wrote:
> 
> Why would there be problems?

I'm just asking since I don't know well 64 bits architectures. :)

However, how can I fix 64 bits seconds into struct timespec?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
