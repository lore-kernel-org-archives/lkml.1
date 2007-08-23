Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbXHWJ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbXHWJ0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbXHWJ0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:26:25 -0400
Received: from paf87.warszawa.sdi.tpnet.pl ([217.96.225.87]:13275 "EHLO
	qrnik.knm.org.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297AbXHWJ0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:26:24 -0400
X-Greylist: delayed 2189 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 05:26:20 EDT
Subject: Re: [PATCH] setpgid(child) fails if the child was forked by
	sub-thread
From: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070822103052.d06e2645.randy.dunlap@oracle.com>
References: <bug-8921-10286@http.bugzilla.kernel.org/>
	 <20070822082517.321edfa5.akpm@linux-foundation.org>
	 <20070822165539.GA191@tv-sign.ru>
	 <20070822100802.c2c202f9.randy.dunlap@oracle.com>
	 <20070822172436.GA1635@tv-sign.ru>
	 <20070822103052.d06e2645.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-2
Date: Thu, 23 Aug 2007 10:49:33 +0200
Message-Id: <1187858974.4452.1.camel@qrnik>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 PLD Linux 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 22-08-2007, ¦r o godzinie 10:30 -0700, Randy Dunlap napisa³(a):

> > > so "fixes http://bugzilla.kernel.org/show_bug.cgi?id=8921"  ??
> > 
> > Hopefully yes... should I add some note at /bugzilla.kernel.org?
> 
> I think that it can wait until Marcin confirms that it's fixed
> (if he does so soon), then mark 8921 as fixed.

Yes, it's fixed. Thank you!

-- 
   __("<         Marcin Kowalczyk
   \__/       qrczak@knm.org.pl
    ^^     http://qrnik.knm.org.pl/~qrczak/

