Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbXJZUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbXJZUuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXJZUuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:50:11 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49016 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbXJZUuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:50:09 -0400
Date: Fri, 26 Oct 2007 22:52:44 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20071026205244.GD19019@enneenne.com>
References: <20071026105125.GA28769@enneenne.com> <20071026151141.GA4321@flint.arm.linux.org.uk> <20071026154705.GY19019@enneenne.com> <20071026160206.GC4321@flint.arm.linux.org.uk> <20071026162705.GZ19019@enneenne.com> <20071026163651.GD4321@flint.arm.linux.org.uk> <20071026165400.GA19019@enneenne.com> <20071026170030.GE4321@flint.arm.linux.org.uk> <20071026171857.GC19019@enneenne.com> <20071026183740.GF4321@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026183740.GF4321@flint.arm.linux.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 07:37:40PM +0100, Russell King wrote:
> On Fri, Oct 26, 2007 at 07:18:57PM +0200, Rodolfo Giometti wrote:
> > On Fri, Oct 26, 2007 at 06:00:31PM +0100, Russell King wrote:
> > > Or that - probably a sysfs attribute on the pcmcia socket would be
> > > better.
> > 
> > Ok, but how can I do it? Can you please suggest to me the name of such
> > attribute and where should I add it into the PCMCIA code? Also, which
> > should be the default dehaviour? ;)
> 
> My consulting rates are...  Seriously, if you want me to write a patch
> for you, you have to pay for that.

O_o You misunderstand me... I just like some hints about to do it by
myself.

Since (most probably) you are the one which should accept or deny my
patch I simple asked to you how I should do the job in order to avoid
a reject! :)

The name of the attribute, which should be its default behaviour and
an hint where should I put the code (just a file name or a function
one).

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
