Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbXI3VoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbXI3VoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 17:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbXI3Vn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 17:43:57 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:48716 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbXI3Vn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:43:56 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Fwd: [Suspend2-devel] [patch] 2.2.10.3 build fixes
Date: Mon, 1 Oct 2007 07:43:52 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: nigel@suspend2.net, "Linux-pm mailing list" <uclinux-v850@lsi.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
References: <200709302144.08688.nigel@nigel.suspend2.net> <200709302156.45894.rjw@sisk.pl>
In-Reply-To: <200709302156.45894.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710010743.52628.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Monday 01 October 2007 05:56:45 Rafael J. Wysocki wrote:
> Hi,
> 
> On Sunday, 30 September 2007 13:44, Nigel Cunningham wrote:
> > Hi Rafael et al.
> > 
> > This looks like it will be vanilla material, maybe 2.6.23 material?
> 
> Well, I wouldn't like to export freezer.h .  Why exactly would that be
> necessary?

A module that starts a freezeable kthread?

I can ask for more details, and will if you like.

Regards,

Nigel
-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
