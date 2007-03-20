Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbXCTObX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbXCTObX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933509AbXCTObX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:31:23 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:36869 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933504AbXCTObW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:31:22 -0400
Message-ID: <45FFF026.4030502@gmail.com>
Date: Tue, 20 Mar 2007 15:31:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, pavel@suse.cz, linux-pm@lists.osdl.org
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 Mar 2007 15:31:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/

I'm getting this while trying to swsusp:
Stopping tasks ...
Stopping kernel threads timed out after 20 seconds (1 tasks refusing to freeze):
 swapper
 Restarting tasks ... done.

What to test? Enable PM_DEBUG?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
