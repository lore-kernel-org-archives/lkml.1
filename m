Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbXGOSfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbXGOSfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 14:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXGOSfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 14:35:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:41297 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752079AbXGOSfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 14:35:05 -0400
X-Authenticated: #26239675
X-Provags-ID: V01U2FsdGVkX1+mzAMsl+imKKjOzl/HkAGd0X3h5qtgA8zmuaIP3p
	IsFzEdmE16pUdp
Message-ID: <469A8515.3080109@gmx.de>
Date: Sun, 15 Jul 2007 20:35:33 +0000
From: Cornelius Riemenschneider <c.r1@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070711)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
References: <200707151433.34625.rjw@sisk.pl>
In-Reply-To: <200707151433.34625.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I think a (10) is needed to be clear:

(10) This depends directly on (9)
Easy Userinterface for the average user, no one wants to edit several
files and use a long commandline for a suspend (not all know about
alias(P)), so keeping the effort to suspend your system low, please.(eg
for my TuxOnIce i just type hibernate as root/ sudo hibernate as normal
user and the suspend begin, the rest is automatically done by the
configuration(for me this is shutting down my wireless interface)

Cornelius Riemenschneider

My source of power: www.humppa.com
