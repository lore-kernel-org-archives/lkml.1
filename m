Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYFOKu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYFOKu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbYFOKuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:50:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52325 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbYFOKuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:50:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
Date: Sun, 15 Jun 2008 12:51:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       "werner" <werner@copaya.yi.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806151251.43070.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 of June 2008, Linus Torvalds wrote:
> 
> On Sat, 14 Jun 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10912
> > Subject		: Regressions in the last kernels
> > Submitter	: werner <werner@sys-linux.yi.org>
> > Date		: 2008-06-14 18:26 (1 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121346933911641&w=4
> 
> I don't believe this is a regression, at least the 8GB thing.

No, it is not.  The other problem described in this message seems to be a
recent regression, though, at least the reporter thinks so.

Thanks,
Rafael

