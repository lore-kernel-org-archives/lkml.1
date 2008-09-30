Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYI3Q2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYI3Q2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYI3Q2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:28:17 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:35982 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYI3Q2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:28:16 -0400
Date: Tue, 30 Sep 2008 13:28:31 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com, herton@mandriva.com.br
Subject: Re: Linux 2.6.27-rc8
Message-ID: <20080930132831.1cc4d56c@doriath.conectiva>
In-Reply-To: <48E1DC40.2020508@tremplin-utc.net>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	<Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
	<alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
	<21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
	<alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org>
	<alpine.LNX.1.10.0809300906550.4022@jikos.suse.cz>
	<48E1DC40.2020508@tremplin-utc.net>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 30 Sep 2008 09:58:56 +0200
Eric Piel <eric.piel@tremplin-utc.net> escreveu:

| Jiri Kosina schreef:
| > On Mon, 29 Sep 2008, Linus Torvalds wrote:
| > 
| >>> If it is X related then its both a kernel + X server issue, the e1000e 
| >>> driver opens the barn door, the X server drives the horses through it.
| >> Are you sure? There was a mandriva report abou NVM corruption on an e100 
| >> too (that one apparently just caused PXE failure, the networking worked 
| >> fine).
| > 
| > That is very probably completely separate issue, and shoudl have been 
| > fixed already by 78566fecb.
| Likely not, you are mentioning a patch for e1000, while the Mandriva bug 
| report is about e100:
| https://qa.mandriva.com/show_bug.cgi?id=44192

 Yes, also the reporter has said that he has got the problem with -rc7 and
this fix is available since -rc6.

 Jiri, doesn't e100 need that fix as well?

 Anyway, it is not clear for us whether this is a kernel problem. We
could not reproduce it here and the reporter is now checking his network.

-- 
Luiz Fernando N. Capitulino
