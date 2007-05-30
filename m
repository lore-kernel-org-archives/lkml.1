Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbXE3ApJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbXE3ApJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXE3Aov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:44:51 -0400
Received: from gromalin.logidee.com ([213.91.4.12]:3553 "EHLO
	gromalin.logidee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbXE3Aou (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:44:50 -0400
X-Greylist: delayed 1701 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 20:44:50 EDT
Date: Wed, 30 May 2007 02:13:50 +0200
From: Stephane Casset <sept@logidee.com>
To: Ian Kumlien <iank@bredband.net>
Cc: Linux-kernel@vger.kernel.org
Subject: Re: [BUG] Something goes wrong with timer statistics.
Message-ID: <20070530001350.GD9086@gromalin.logidee.com>
References: <1180474738.22497.25.camel@pi.pomac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1180474738.22497.25.camel@pi.pomac.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, May 29, 2007 at 11:38:48PM +0200, Ian Kumlien écrivait :
> Hi, 
> 
> As the daystar sets, i try to play some with my new would be
> firewall/server, but since this will be running for quite some time i
> have been experimenting with powertop to find out what i can do to limit
> it's power usage.
> 
> But, if i run powertop for too long or a few times to many... this
> happens:
> http://pomac.netswarm.net/pics/kernel_panic.jpg
> 
> If i don't run powertop, it is rock solid... Compiling for hours,
> running memtest for hours etc etc... 

Same here, P4 HT, if I run powertop for 5-10 minutes the system crash :(
It happens with 2.6.22-rc{2,3} at least :( I didn't try before.

I don't have a oops since the last crash was in X, but next time I will
try to catch it. If there is any patch around to fix this I am willing
to test.

Regards
-- 
Stéphane Casset            LOGIDÉE sàrl       Se faire plaisir d'apprendre
1a, rue Pasteur        Tel : +33 388 23 69 77           casset@logidee.com
F-67540 OSTWALD        Fax : +33 388 23 69 77           http://logidee.com
