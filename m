Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbXFNC5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbXFNC5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbXFNC5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:57:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42188 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbXFNC5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:57:41 -0400
Message-ID: <4670AEA1.8030409@garzik.org>
Date: Wed, 13 Jun 2007 22:57:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Blackfin updates for 2.6.22-rc4
References: <1181786785.21995.5.camel@roc-desktop>
In-Reply-To: <1181786785.21995.5.camel@roc-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> Hi Linus:
> 
> Sorry for word-wrapping in previous git pull request email.
>  
> please pull from:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git master

You should run your patch through scripts/checkpatch.pl before 
pushing... there are several notables in there like tons of trailing 
whitespace, use of spaces rather than tabs, lack of whitespace inside 
expressions, etc.

The "line over 80 chars" warning can get a bit obnoxious, if you are 
barely over the limit, but the other warnings are pretty reasonable.


