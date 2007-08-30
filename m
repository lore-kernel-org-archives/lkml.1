Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbXH3CHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbXH3CHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 22:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXH3CHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 22:07:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:46065 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbXH3CHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 22:07:36 -0400
Message-ID: <46D62661.5010608@windriver.com>
Date: Wed, 29 Aug 2007 21:07:29 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: pete@bluelane.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net, amitkale@linsyssoft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [Kgdb-bugreport] 2.6.23-rc3-mm1: kgdb build failure on powerpc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<200708222104.29432.m.kozlowski@tuxland.pl>	<20070822124743.fc316963.akpm@linux-foundation.org>	<46CCBC3C.7010307@windriver.com> <20070822165318.b82da13c.akpm@linux-foundation.org> <46CCFE2C.4050306@windriver.com> <46D604BF.7090905@bluelane.com> <46D61B21.1010703@bluelane.com>
In-Reply-To: <46D61B21.1010703@bluelane.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2007 02:07:07.0849 (UTC) FILETIME=[77CB2390:01C7EAAA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete/Piet Delaney wrote:
> Why am I getting this when I do:
>
> git clone
> http://master.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
>   

I have only ever used:

git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git


Jason.
