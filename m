Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYCQVBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYCQVBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYCQVAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:00:54 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:34867 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbYCQVAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:00:52 -0400
Date: Mon, 17 Mar 2008 22:00:45 +0100
From: Jan Kasprzak <kas@fi.muni.cz>
To: Malte =?iso-8859-1?Q?Schr=F6der?= <maltesch@gmx.de>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot (resend)
Message-ID: <20080317210045.GG3189@fi.muni.cz>
References: <20080214184700.0bd3837d@highlander.home.lan> <47B4D02E.9030101@gmail.com> <20080215191215.430ee2e0@highlander.home.lan> <47BCE71F.2000309@gmail.com> <20080221172757.44882428@highlander.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080221172757.44882428@highlander.home.lan>
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 17 Mar 2008 22:00:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Malte Schröder wrote:
: I "solved" the problem by updating the BIOS. It now works perfectly. I
: thought I had mailed that .. maybe I forgot.

	I have the same problem (ASUS M2R32-MVP board with SB600 chipset,
Athlon64 X2), but I am already using the latest BIOS for this mainboard.

2.6.22.19 works
2.6.24.3 does not work
2.6.25-rc6 does not work

	I can try to bisect it (maybe tomorrow).
I use AHCI mode, maybe I should try the legacy mode as well.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<
