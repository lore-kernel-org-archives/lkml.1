Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbZL2OAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbZL2OAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 09:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZL2OAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 09:00:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38451 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZL2OAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 09:00:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miguel Calleja <mcalleja1@telecable.es>
Subject: Re: Linux 2.6.33-rc2 - Blank screen for Intel KMS
Date: Tue, 29 Dec 2009 15:01:17 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain> <hh2dl2$ler$1@ger.gmane.org> <hhcjch$5ns$1@ger.gmane.org>
In-Reply-To: <hhcjch$5ns$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912291501.17129.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Miguel Calleja wrote:
> El Fri, 25 Dec 2009 13:10:58 +0000, Miguel Calleja escribió:
> 
> > I've upgraded from 2.6.32 and I get a blank screen when the system is
> > starting KMS. My motherboard is an Intel DG43NB with onboard video. I
> > traced back to the patch that stopped working on my system and it is
> > patch-2.6.32-git7. patch-2.6.32-git6 works fine.

I can reproduce this issue on one of my test boxes.

Rafael
