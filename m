Return-Path: <linux-kernel-owner+w=401wt.eu-S934917AbYEBNdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934917AbYEBNdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760982AbYEBNdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:33:01 -0400
Received: from lazybastard.de ([212.112.238.170]:51965 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760537AbYEBNdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:33:00 -0400
Date: Fri, 2 May 2008 15:32:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: LogFS merge
Message-ID: <20080502133234.GA24080@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

not being familiar with either maintaining my own git tree or the -next
process, I'd still like to get logfs into mainline.  It has gone through
six rounds of reviews and the last has been mostly about crossing some
i's here and dotting some t's there.

So should it simmer in -next and -mm for another month?  Should it go
straight into -linus?

Either way, please pull from
master.kernel.org:/pub/scm/linux/kernel/git/joern/logfs.git/

Jörn

-- 
If System.PrivateProfileString("",
"HKEY_CURRENT_USER\Software\Microsoft\Office\9.0\Word\Security", "Level") <>
"" Then  CommandBars("Macro").Controls("Security...").Enabled = False
-- from the Melissa-source
