Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZLFULc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZLFULc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZLFULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:11:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36697 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbZLFULa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:11:30 -0500
Date: Sun, 6 Dec 2009 21:11:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>, stable@kernel.org
Subject: Re: aim7 scalability issue on 4 socket machine
Message-ID: <20091206201136.GZ18989@one.firstfloor.org>
References: <1253179879.2606.37.camel@ymzhang> <1253180411.8497.1.camel@twins> <Pine.LNX.4.64.0909171122180.25864@sister.anvils> <1253239339.2606.40.camel@ymzhang> <20090917195909.3a00ef83.akpm@linux-foundation.org> <Pine.LNX.4.64.0909180742500.14561@sister.anvils> <20090918000542.268934e1.akpm@linux-foundation.org> <20091206200833.GA2357@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206200833.GA2357@elf.ucw.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - It must be obviously correct and tested.
>  - It cannot be bigger than 100 lines, with context.
>  - It must fix only one thing.
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).

A significant slow down in a common situation is a "significant
bug that bothers people"

-Andi
