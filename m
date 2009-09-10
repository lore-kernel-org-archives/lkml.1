Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZIJUwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZIJUwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZIJUwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:52:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40552 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZIJUwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:52:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Karsten Mehrhoff <kawime@gmx.de>
Subject: Re: [Bug #13318] AGP doesn't work anymore on nforce2
Date: Thu, 10 Sep 2009 22:53:46 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "Jerome Glisse" <glisse@freedesktop.org>,
       Michel =?utf-8?q?D=C3=A4nzer?= <michel@daenzer.net>,
       "Shaohua Li" <shaohua.li@intel.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <hKF51Pczj6N.A.2PB.55BpKB@chimera> <op.uz1iefpygp7xae@127.0.0.1>
In-Reply-To: <op.uz1iefpygp7xae@127.0.0.1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909102253.46839.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 September 2009, Karsten Mehrhoff wrote:
> Hi all,
> 
> Today i compilied the new kernel 2.6.31 and everything works ok.
> Maybe it's related to other changes in the generic.c file.
> 
> So everything works ok for me with AGP in 2.6.31.
> I do not get the problem like it was in 2.6.30.x

Thanks for the update, I closed the bug.

Best,
Rafael
