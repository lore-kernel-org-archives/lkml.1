Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797Ab0AQNne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0AQNne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504Ab0AQNnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:43:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40258 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab0AQNnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:43:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
Date: Sun, 17 Jan 2010 14:44:14 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4B4E1633.8010700@pardus.org.tr> <201001162312.34189.rjw@sisk.pl> <4B52D6E2.8000904@pardus.org.tr>
In-Reply-To: <4B52D6E2.8000904@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001171444.14551.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 January 2010, Ozan Çağlayan wrote:
> Rafael J. Wysocki wrote:
> 
> > 
> > Well, the problem is I'm not listing regressions from 2.6.31 any more.
> > 
> > Also, I don't have hardware to reproduce the problem on.
> > 
> > Is there a bug entry for this in the kernel Bugzilla?
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=15075

I linked it to http://bugzilla.kernel.org/show_bug.cgi?id=13615 as a regression
from 2.6.30.

Rafael
