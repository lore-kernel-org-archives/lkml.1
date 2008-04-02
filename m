Return-Path: <linux-kernel-owner+w=401wt.eu-S1762315AbYDBVLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315AbYDBVLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYDBVKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:10:55 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:6640 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbYDBVKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:10:55 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 17:10:54 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUEAHOQ80fEAmHEZGdsb2JhbACRQxwRGJo6
From: Bongani Hlope <bhlope@mweb.co.za>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc7-git5: Reported regressions from 2.6.24
Date: Wed, 2 Apr 2008 23:00:51 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       video4linux-list@redhat.com
References: <200803310228.11027.rjw@sisk.pl>
In-Reply-To: <200803310228.11027.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804022300.52031.bhlope@mweb.co.za>
X-Original-Subject: Re: 2.6.25-rc7-git5: Reported regressions from 2.6.24
X-Scan-Signature: ed68039656d6c67732da46003ca818d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008 02:28:10 Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.24, for which
> there are no fixes in the mainline I know of.  If any of them have been
> fixed already, please let me know.
>
> If you know of any other unresolved regressions from 2.6.24, please let me
> know either and I'll add them to the list.  Also, please let me know if any
> of the entries below are invalid.
>

Hi Rafael

8<

>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10027
> Subject		: 2.6.25-rc[12] Video4Linux Bttv Regression
> Submitter	: Bongani Hlope <bonganilinux@mweb.co.za>
> Date		: 2008-02-17 09:36 (43 days old)
> References	: http://lkml.org/lkml/2008/2/17/55
>

This has been fixed and tested, the patch is in Linus' tree this is the git 
commit 49115b7cb1483a14c557666b61fe81d3c23780d6. You can close the bug now.

Thanks
