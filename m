Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYEAQ1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYEAQ1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761953AbYEAQ1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:27:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:3218 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760890AbYEAQ1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=mEjmgRTeX9ole8dii/hRNg622E+qaSCPT6ygEFIcsZCZPRKmoi7Yblba76WPz1dGM2+IRCSnBG1JRP0+pQtpjd6xriDVEq5gExIMR73Z7VCZL4O80fNsWPGl2m6W+fc1IaYKRiHTwfu93tvtA6HzCbz6jgwqyozXEfLYqEvKXS8=
Date: Thu, 1 May 2008 18:26:58 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       mingo@elte.hu, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080501182658.9bbf5d4a.diegocg@gmail.com>
In-Reply-To: <4818F291.2050706@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080430135405.ddc42075.akpm@linux-foundation.org>
	<4818E7E3.7080705@gmail.com>
	<20080430151007.0ace4fa2.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301513350.2980@woody.linux-foundation.org>
	<4818F291.2050706@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 01 May 2008 02:28:33 +0400, Dmitri Vorobiev <dmitri.vorobiev@gmail.com> escribió:

> Linus, thanks a lot for the detailed explanation. Indeed, it seems that I foolishly
> tried to duplicate Stephen's work. In the future I'll do as you suggest here.

That "howto" should probably be added to the linux-next announcements...
(CC'ing Stephen)
