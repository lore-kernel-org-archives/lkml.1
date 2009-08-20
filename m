Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZHTTgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZHTTgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZHTTgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:36:12 -0400
Received: from ppp-136-40.adsl.restena.lu ([158.64.136.40]:53828 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZHTTgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:36:11 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 15:36:10 EDT
Date: Thu, 20 Aug 2009 21:29:59 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13942] Troubles with AoE and uninitialized object
Message-ID: <20090820212959.0ece42e3@neptune.home>
In-Reply-To: <ADSuNT6McuD.A.1t.BOIjKB@chimera>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	<ADSuNT6McuD.A.1t.BOIjKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 August 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
> Subject		: Troubles with AoE and uninitialized object
> Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
> Date		: 2009-08-04 10:12 (16 days old)
> References	:
> http://marc.info/?l=linux-kernel&m=124938117104811&w=4
> 

This one is still valid for 2.6.31-rc6 though I have not yet taken
the time to attempt bisecting it. I will probably bisect over the
week-end.

Bruno
