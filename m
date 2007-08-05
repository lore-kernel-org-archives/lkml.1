Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbXHEJhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbXHEJhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 05:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXHEJhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 05:37:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:55620 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752169AbXHEJhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 05:37:03 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/1dlkktb31UkcMXSJ23L0spnSXLrpDbV51iybRnt
	AC4er+wt+vtkEo
Message-ID: <46B599CA.9030302@gmx.net>
Date: Sun, 05 Aug 2007 11:35:06 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Andrey Savochkin <saw@sw.ru>,
       Adrian Bunk <bunk@stusta.de>, Cedric Le Goater <clg@fr.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: CLONE_NEWUTS documentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Serge,

In 2.6.19, your patch to add support for CLONE_NEWUTS was included.  Is
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
