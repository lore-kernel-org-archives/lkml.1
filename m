Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYA1Ptd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYA1Ptd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYA1PtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:49:25 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:48063 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYA1PtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:49:24 -0500
Date: Mon, 28 Jan 2008 16:52:09 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Message-ID: <20080128155209.GI11364@enneenne.com>
References: <20080127173923.GT11364@enneenne.com> <20080128134308.GC16173@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128134308.GC16173@csclub.uwaterloo.ca>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS patch
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 08:43:08AM -0500, Lennart Sorensen wrote:

> I would test it except I am still on 2.6.18 and probably will be for
> quite a while.  I am still using an older patch of yours which works
> great for now, although I know the interface has a changed a bit since.

Yes, you are referring to a very old job, please update your kernel
and test this patch (if you can, of course :) since version 2.6.18 is
no more supported (even if you can try to backport this patch...).

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
