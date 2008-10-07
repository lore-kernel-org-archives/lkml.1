Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYJGU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYJGU1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYJGU1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:27:13 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39082 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYJGU1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:27:11 -0400
Date: Tue, 7 Oct 2008 22:27:06 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20081007202706.GN13035@tekkaman>
References: <1223044589-31741-1-git-send-email-giometti@linux.it> <1223044589-31741-2-git-send-email-giometti@linux.it> <20081003215923.GA14890@kroah.com> <20081007093845.GD13035@tekkaman> <20081007173020.GA16654@kroah.com> <20081007191434.GK13035@tekkaman> <20081007200031.GA7662@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007200031.GA7662@kroah.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] Add c2 port support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 01:00:31PM -0700, Greg KH wrote:

> Well, having a "core" with no clients doesn't make much sense, so you
> should probably post some users of this code, otherwise why even have
> it?

Ok, I'll post at least the x86 client. However I posted the core in
case someone may need it. ;)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
