Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZDHWHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZDHWHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZDHWHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:07:35 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1515 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZDHWHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:07:34 -0400
Subject: Re: [PATCH 54/56] x86: Remove void casts
From: Joe Perches <joe@perches.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
In-Reply-To: <49DD0D02.3030604@fastmail.fm>
References: <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com>
	 <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu>
	 <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu>
	 <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu>
	 <49DCBA61.8060507@fastmail.fm> <20090408145715.GO12931@elte.hu>
	 <49DCBBDF.4040603@fastmail.fm> <20090408151644.GQ12931@elte.hu>
	 <49DD0D02.3030604@fastmail.fm>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 15:06:00 -0700
Message-Id: <1239228360.32205.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 21:45 +0100, Jack Stone wrote:
> That has already been done. Someone just so happened to submit
> such a patch today.
> http://marc.info/?l=linux-kernel&m=123916809504492&w=2

It's been floating around for awhile now.

If you're using git send-email, you could try adding
--cc-cmd "scripts/get_maintainer.pl patchfile" 

Here are some descriptions of available options
http://lkml.org/lkml/2008/10/27/479

Let me know how it works for you.

cheers, Joe

