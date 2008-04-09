Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYDIQ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYDIQ4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYDIQ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:56:24 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58036 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYDIQ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:56:23 -0400
Message-ID: <47FCF50E.9090703@s5r6.in-berlin.de>
Date: Wed, 09 Apr 2008 18:55:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 9
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
In-Reply-To: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> There were a few merge conflicts (fairly trivial) and couple of build
> failures (notified).  There is a know build failure with powerpc
> allyesconfig.  Below is a summary of the state of the merge.
...
> Merging ieee1394/for-next
> CONFLICT (content): Merge conflict in lib/Kconfig.debug

Would it be safe for me (and preferred by you) to merge sched/for-akpm
into ieee1394/for-next to resolve this conflict until next mainline merge?
-- 
Stefan Richter
-=====-==--- -=-- -=--=
http://arcgraph.de/sr/
