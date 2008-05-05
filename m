Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYEESKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYEESKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYEESKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:10:46 -0400
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:56820 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750871AbYEESKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:10:45 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Wessel <jason.wessel@windriver.com>
Subject: Re: kgdboe?
Date: Mon, 5 May 2008 11:10:32 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <481EFE69.20308@windriver.com>
In-Reply-To: <481EFE69.20308@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051110.32238.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2008 5:32 am Jason Wessel wrote:
> Linus, please pull from the for_linus branch at:
>
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
> for_linus
>
> These are the fixes since the initial kgdb merge.
>
> Thanks,
> Jason.
>
> ---
> Harvey Harrison (2):
>       kgdb: trivial sparse fixes in kgdb test-suite
>       kgdb: fix signedness mixmatches, add statics, add declaration to
> header
>
> Jan Engelhardt (1):
>       kgdb: kconfig fix xconfig/menuconfig element
>
> Jason Wessel (1):
>       kgdb: 1000 loops for the single step test in kgdbts
>
> grzegorz.chwesewicz@chilan.com (1):
>       kgdb: minor documentation fixes

So when will we see kgdboe or some other way of getting gdb to connect to the 
target over ethernet upstream?

Jesse
