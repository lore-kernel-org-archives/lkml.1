Return-Path: <linux-kernel-owner+w=401wt.eu-S1761074AbXHEJhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbXHEJhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 05:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbXHEJhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 05:37:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:39105 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751772AbXHEJhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 05:37:02 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/6YZRrS0T6UV5TNsRsAw43uyzYICzUPtkxXx2uhL
	do/iMW9CujDHR6
Message-ID: <46B599D8.8010003@gmx.net>
Date: Sun, 05 Aug 2007 11:35:20 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Kirill Korotaev <dev@openvz.org>
CC: lkml <linux-kernel@vger.kernel.org>, Pavel Emelianov <xemul@openvz.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: CLONE_NEWIPC documentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kirill,

In 2.6.19, your patch to add support for CLONE_NEWIPC was included.  Is
there there some for-userland-programmers documentation of this flag
somewhere?  Would you be able to send some documentation to me (ideally as
a patch to the clone.2 man page, but otherwise some plain text will do).

If this flag is also supported for unshare(), then could you please send me
a patch/text for that too?

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
