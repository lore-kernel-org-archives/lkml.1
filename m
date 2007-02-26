Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbXBZAS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbXBZAS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 19:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXBZAS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 19:18:26 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44266 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbXBZASZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 19:18:25 -0500
Date: Mon, 26 Feb 2007 01:18:24 +0100
From: Adrian Bunk <bunk@stusta.de>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/18] 2.6.18-stable review
Message-ID: <20070226001824.GI29575@stusta.de>
References: <20070221014927.GA3684@kroah.com> <200702211355.05539.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702211355.05539.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 01:55:04PM +0200, S.Çağlar Onur wrote:
> 21 Şub 2007 Çar tarihinde, Greg KH şunları yazmıştı: 
> > Responses should be made by Friday February 23 00:00 UTC.  Anything
> > received after that time might be too late.
> 
> We have still some CVEish patches in our package which maybe you want to 
> consider adding into -stable.

Below, I'll only look at the 2.6.18, 2.6.19 and 2.6.20 kernels.

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-4814

fixed in:
- 2.6.18.8
- 2.6.19.2
- 2.6.20

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5749

fixed in:
- 2.6.20 (commit dab6df63086762629936e8b89a5984bae39724f6)

missing in:
- 2.6.18
- 2.6.19

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5753

fixed in:
- 2.6.20 (commit be6aab0e9fa6d3c6d75aa1e38ac972d8b4ee82b8)

missing in:
- 2.6.18
- 2.6.19

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5823

fixed in:
- 2.6.19.2
- 2.6.20

missing in:
- 2.6.18

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6053

fixed in:
- 2.6.19.2
- 2.6.20

missing in:
- 2.6.18

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6054

fixed in:
- 2.6.19.2
- 2.6.20

missing in:
- 2.6.18

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6333

fixed in:
- 2.6.19.1
- 2.6.20

problem not present in:
- 2.6.18

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0006

fixed in:
- 2.6.19.5

missing in:
- 2.6.18
- 2.6.20

> Cheers

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

