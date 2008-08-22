Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYHVIyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYHVIyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 04:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYHVIyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 04:54:25 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38266 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYHVIyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 04:54:24 -0400
Date: Fri, 22 Aug 2008 10:53:57 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Message-ID: <20080822085357.GD21330@tekkaman>
References: <1219238170-5508-1-git-send-email-giometti@linux.it> <48ADE317.5030809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ADE317.5030809@zytor.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS (RESUBMIT 7): the PPS Linux implementation.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 02:50:15PM -0700, H. Peter Anvin wrote:

> 1. Does this support (calibrated) sources with frequency other than
>    1 Hz?

No. PPS means Pulse-Per-Second. However the code can be used with
different frequencies is up to the userland apps to manage this fact.

> And a minor note: you use the term CD (Carrier Detect), but in most  
> references the pin is labelled DCD (Data Carrier Detect).

You are right. :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
