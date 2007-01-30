Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbXA3IhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbXA3IhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXA3IhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:37:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:63630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbXA3IhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:37:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org, maynardj@us.ibm.com
Subject: Re: [RFC, PATCH 0/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Tue, 30 Jan 2007 09:37:07 +0100
User-Agent: KMail/1.9.5
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net
References: <45BE4ED0.5030808@us.ibm.com>
In-Reply-To: <45BE4ED0.5030808@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701300937.07335.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+QNwSTUvlROIQjaihd3RKJA4ZOaPuankBAlEYmzIvXwKHGCad6Pgbg3tgKEDIFIWYMV1PlJC6dWyQd9JCK24y0PUibiKOAD90YBaI4CwIqjw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 January 2007 20:45, Maynard Johnson wrote:
> On December 14, 2006, I posted a patch that added support to the 
> OProfile kernel driver for profiling Cell SPUs.  There have been some 
> changes/fixes to this patch since the original posting (including 
> forward porting from 2.6.18-based kernel to 2.6.20-rc1), so I am 
> reposting the patch for review now.  This patch relies upon the 
> following patches that have not been accepted yet:
>    1. oprofile cleanup patch (submitted on Nov 27)
>    2. Fix for PPU profiling (not submitted yet, since it depends on #1)
>    3. SPU task notification patch (last submitted on Jan 26)
> 

Sorry for taking so much time before reviewing this. I knew it would
be a long patch that requires time to go through in detail (though
certainly not nearly as much time as it took you to write it), so I
kept procrastinating.

	Arnd <><
