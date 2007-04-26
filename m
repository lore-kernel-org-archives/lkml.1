Return-Path: <linux-kernel-owner+w=401wt.eu-S1031506AbXDZXcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031506AbXDZXcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031514AbXDZXcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:32:10 -0400
Received: from mx3.mail.ru ([194.67.23.149]:3420 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031506AbXDZXcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:32:08 -0400
Date: Fri, 27 Apr 2007 03:29:02 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org, David Woodhouse <dwmw2@infradead.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [ANNOUNCE] battery2 git repository
Message-ID: <20070426232902.GA10423@zarina>
Reply-To: cbou@mail.ru
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

David Woodhouse has been *very* kind enough to provide git repository
for the battery stuff I've posted recently.

Much thanks, David!


To not confuse with David own battery-2.6 repository, it's called
battery2-2.6, and can be found here:

http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=summary

You can get it using "git clone --reference linux-2.6 \
git://git.infradead.org/users/cbou/battery2-2.6.git" command.

Now anyone interested can track changes and/or improve it.

As time will permit I'll port Apple PMU and OLPC drivers to new
battery class.

Good luck,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
