Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYBKJxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYBKJxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYBKJuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:46 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:43333 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbYBKJuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:44 -0500
Date: Mon, 11 Feb 2008 10:53:46 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Message-ID: <20080211095346.GA28885@enneenne.com>
References: <1202493644764-git-send-email-giometti@linux.it> <120249364418-git-send-email-giometti@linux.it> <20080209064531.GA29926@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209064531.GA29926@kroah.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/8] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 10:45:31PM -0800, Greg KH wrote:
> 
> As you are adding sysfs files, please also describe them in
> Documentation/ABI/ in this same series of patches.

Ok. I'm going to add them under "testing".

> Why not use a default attribute group?
> 
> That way the files are created before the uevent is issued, and the
> amount of code you have to write is much smaller.

What do you mean exactly? I don't understand what you wish. :'(

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
