Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbXGVIzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbXGVIzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbXGVIza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:55:30 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39201 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154AbXGVIz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:55:29 -0400
Date: Sun, 22 Jul 2007 10:56:23 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20070722085623.GB22671@enneenne.com>
References: <20070721130256.GA22671@enneenne.com> <200707211447.22364.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707211447.22364.david-b@pacbell.net>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [linux-usb-devel] PXA27x UDC driver GIT repository
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 02:47:22PM -0700, David Brownell wrote:
> On Saturday 21 July 2007, Rodolfo Giometti wrote:
> > I reworked the driver according to latest suggestions from you.
> 
> ... except for the most important one, which is to remove the
> requirement to change every part of the gadget driver stack to
> work around quirks in that particular hardware!!
> 
> I hope patches to resolve that issue get contributed soonish.

Yes I know, but currently I have no time to modify the code as you
suggested.

I published functional code so people can use it and (maybe)
contribute to resolve the problem that you arise.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
