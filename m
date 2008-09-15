Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbYIOAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbYIOAVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 20:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYIOAVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 20:21:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51024 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYIOAVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 20:21:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [Bug #11554] Partition check considered as error is breaking mounting in 2.6.27
Date: Mon, 15 Sep 2008 02:25:48 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Abdel Benamrouche" <draconux@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.oyF.sbsyIB@albercik> <200809132037.55922.herton@mandriva.com.br>
In-Reply-To: <200809132037.55922.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809150225.50173.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 14 of September 2008, Herton Ronaldo Krzesinski wrote:
> On Friday 12 September 2008 16:06:31 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11554
> > Subject		: Partition check considered as error is breaking mounting in 2.6.27
> > Submitter	: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > Date		: 2008-09-12 16:56 (1 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122123862519434&w=4
> > 
> 
> Fixed now with commit 8d99f83b9478768d3a8d7d1bcd9bd182c75a0447

Thanks, closed.

Rafael
