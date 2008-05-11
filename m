Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbYEKVPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbYEKVPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbYEKVB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34195 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854AbYEKVBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:53 -0400
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Mikael Pettersson" <mikpe@it.uu.se>, "Pavel Machek" <pavel@suse.cz>,
       "Sam Ravnborg" <sam@ravnborg.org>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.48F.Wv1JIB@chimera>
Subject: [Bug #10676] 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10676
Subject		: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-05-10 20:18 (2 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121045079732174&amp;w=4
Handled-By	: H. Peter Anvin <hpa@zytor.com>
		  Sam Ravnborg <sam@ravnborg.org>
		  Cyrill Gorcunov <gorcunov@gmail.com>
		  Pavel Machek <pavel@suse.cz>


