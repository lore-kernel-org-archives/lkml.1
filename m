Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYCKWbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYCKWbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYCKWbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:31:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36780 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYCKWbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:31:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] scheduler fixes
Date: Tue, 11 Mar 2008 23:30:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20080311154837.GA27219@elte.hu>
In-Reply-To: <20080311154837.GA27219@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112330.59149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of March 2008, Ingo Molnar wrote:
> 
> Linus, please pull the latest scheduler fixes git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus
> 
> Thanks,
> 
> 	Ingo
> 
> ------------------>
> Gregory Haskins (2):
>       Revert "cpu hotplug: adjust root-domain->online span in response to hotplug event"
>       keep rd->online and cpu_online_map in sync

Does it fix the poweroff problem reported by Andrew?

Rafael
