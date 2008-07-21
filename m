Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYGUSVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYGUSVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYGUSU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:20:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23878 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYGUSU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:20:57 -0400
Date: Mon, 21 Jul 2008 11:17:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
Subject: Re: INFO: task pdflush:393 blocked for more than 120 seconds. &
 Call traces ... (fwd)
Message-Id: <20080721111729.b8b987b3.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0807210936410.7212@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0807210936410.7212@filesrv1.baby-dragons.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc-ing lkml]


On Mon, 21 Jul 2008 09:40:23 -0800 (AKDT) Mr. James W. Laferriere wrote:

<http://marc.info/?l=linux-raid&m=121666205220699&w=2>


Basically a "me too", on x86_64, 4 proc, 8 GB RAM.

I'm using OLTEST (Oracle Linux test) instead of bonnie.  OLTEST never
finishes because of this.

kernel log (12 MB) is here: http://oss.oracle.com/~rdunlap/kerneltest/logs/netcon-4655.log


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
