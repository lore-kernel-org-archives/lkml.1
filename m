Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbXJVTpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbXJVTpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXJVTpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:45:17 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:60664 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbXJVTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:45:15 -0400
Date: Mon, 22 Oct 2007 21:47:45 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20071022194744.GF20509@enneenne.com>
References: <20071019174113.GE20509@enneenne.com> <20071019175323.GA20453@enneenne.com> <20071021040641.GB24869@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021040641.GB24869@kroah.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: Oops: [RFC] LinuxPPS (pre)patch
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 09:06:41PM -0700, Greg KH wrote:
> 
> Please use a 'struct class' instead of a 'struct class_device'.  We have

Ok, fixed. I'll repost my patch ASAP.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
