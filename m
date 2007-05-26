Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbXEZTFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbXEZTFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbXEZTFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:05:09 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39050
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXEZTFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:05:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 21:04:50 +0200
User-Agent: KMail/1.9.6
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705261750.48816.mb@bu3sch.de> <20070526091309.0af20971.akpm@linux-foundation.org>
In-Reply-To: <20070526091309.0af20971.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262104.51248.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 18:13:09 Andrew Morton wrote:
> > I ask to try wireless-dev, as the driver works perfectly fine
> > for me there, but he refuses to try it, too. So I'm stuck.
> 
> I don't think he knows how to obtain it.
> 
> Uwe, http://userweb.kernel.org/~akpm/git-wireless.patch.gz is the current
> wireless tree.  That's a patch against 2.6.22-rc3.  Could you please test
> that?  If that works then we know that the bug probably lies outside the
> b44 driver (or it was subsequently fixed).

I just tried this patch on my BCM4401-B0 and it works there, too.

-- 
Greetings Michael.
