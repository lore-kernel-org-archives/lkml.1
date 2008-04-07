Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbYDGVeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbYDGVeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYDGVei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:34:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57902 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYDGVeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:34:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
Date: Mon, 7 Apr 2008 23:34:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200804071459.35628.rjw@sisk.pl> <20080407212434.GA27940@elte.hu>
In-Reply-To: <20080407212434.GA27940@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804072334.27059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of April 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10410
> > Subject		: "x86: tsc prevent time going backwards" broke suspend
> > Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> > Date		: 2008-04-07 02:08 (1 days old)
> 
> that's now reverted via 5b13d863573e746739ccfc24ac1a9473cfee8df1.

Yes, Adrian has already closed it.

Thanks,
Rafael
