Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbXI3WNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbXI3WNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXI3WNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:13:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54476 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbXI3WNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:13:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: Fwd: [Suspend2-devel] [patch] 2.2.10.3 build fixes
Date: Mon, 1 Oct 2007 00:28:02 +0200
User-Agent: KMail/1.9.5
Cc: "Linux-pm mailing list" <uclinux-v850@lsi.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
References: <200709302144.08688.nigel@nigel.suspend2.net> <200709302156.45894.rjw@sisk.pl> <200710010743.52628.nigel@nigel.suspend2.net>
In-Reply-To: <200710010743.52628.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710010028.03519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 September 2007 23:43, Nigel Cunningham wrote:
> Hi.
> 
> On Monday 01 October 2007 05:56:45 Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Sunday, 30 September 2007 13:44, Nigel Cunningham wrote:
> > > Hi Rafael et al.
> > > 
> > > This looks like it will be vanilla material, maybe 2.6.23 material?
> > 
> > Well, I wouldn't like to export freezer.h .  Why exactly would that be
> > necessary?
> 
> A module that starts a freezeable kthread?
> 
> I can ask for more details, and will if you like.

Yes, please.

Greetings,
Rafael
