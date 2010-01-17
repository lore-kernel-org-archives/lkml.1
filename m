Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571Ab0AQJWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0AQJWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 04:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090Ab0AQJWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 04:22:42 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:35273 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0AQJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 04:22:39 -0500
Message-ID: <4B52D6E2.8000904@pardus.org.tr>
Date: Sun, 17 Jan 2010 11:22:42 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
References: <4B4E1633.8010700@pardus.org.tr> <4B4F1DE7.307@pardus.org.tr> <4B51B0E8.1010302@pardus.org.tr> <201001162312.34189.rjw@sisk.pl>
In-Reply-To: <201001162312.34189.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> 
> Well, the problem is I'm not listing regressions from 2.6.31 any more.
> 
> Also, I don't have hardware to reproduce the problem on.
> 
> Is there a bug entry for this in the kernel Bugzilla?


http://bugzilla.kernel.org/show_bug.cgi?id=15075
