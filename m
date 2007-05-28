Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbXE1MOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbXE1MOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXE1MN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:13:56 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39211
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXE1MNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:13:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Mon, 28 May 2007 14:12:05 +0200
User-Agent: KMail/1.9.6
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705261750.48816.mb@bu3sch.de> <20070526091309.0af20971.akpm@linux-foundation.org>
In-Reply-To: <20070526091309.0af20971.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705281412.05903.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 18:13:09 Andrew Morton wrote:
> > I already tried your -mm kernel, but it crashes on my machine
> > for other reasons. (Yeah, I should look into them, too :P )
> 
> err, please do.  Just the oops trace would be a start.

Sorry, I can't reproduce the crash anymore. :(

But now I could test that this kernel _also_ works perfectly
well on my BCM4401-B0.

-- 
Greetings Michael.
