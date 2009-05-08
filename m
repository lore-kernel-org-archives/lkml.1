Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZEHWgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZEHWgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZEHWgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:36:16 -0400
Received: from mail.crca.org.au ([67.207.131.56]:50299 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZEHWgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:36:16 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <200905082303.02677.rjw@sisk.pl>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <1241746459.19600.246.camel@nigel-laptop>
	 <200905082144.57955.bzolnier@gmail.com>  <200905082303.02677.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 09 May 2009 08:37:18 +1000
Message-Id: <1241822238.19600.336.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2009-05-08 at 23:03 +0200, Rafael J. Wysocki wrote:
> Also, I think we should aim at targets that are possible to achieve.
> Namely,
> it is clear to me that various parts of TuxOnIce will have to be reviewed and
> commented by the memory management people, the file systems people, the
> architecture-dependent code maintainers and so on, and it is much easier to
> get someone to have a look at a relatively short series of patches doing one
> specific thing at a time than to have him review an entire subsystem.

Seeking review is why I've posted the code.

I'm not sure what file systems people have to review in what I've
posted.

I guess the memory management part would be the separate saving of LRU
pages and the means by which GEM pages are tracked.

Re architecture dependent code maintainers: I don't know what they'd
have to do. Nothing in arch/ is touched by the patches I posted.

Regards,

Nigel

