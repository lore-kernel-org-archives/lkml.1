Return-Path: <linux-kernel-owner+w=401wt.eu-S965014AbXA2X67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014AbXA2X67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965015AbXA2X67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:58:59 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:46821 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965014AbXA2X66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:58:58 -0500
Date: Tue, 30 Jan 2007 00:59:02 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Message-ID: <20070129235902.GB8882@enneenne.com>
References: <20070129230755.GA8705@enneenne.com> <1170114826.5833.139.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170114826.5833.139.camel@localhost.localdomain>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: Advice on APM-EMU reunion
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 11:53:46PM +0000, Richard Purdie wrote:

> I'm not sure this is a good idea. As you're creating a new interface,
> why not create something new/improved without the problems that
> confining yourself to APM emulation brings?

Because several applications (and expecially in embedded systems) use
that interface. However adding a sysfs support I try to define a new
(and most versatile) interface.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
