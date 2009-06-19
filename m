Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbZFSTM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbZFSTM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZFSTMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:12:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38971 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZFSTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:12:49 -0400
Date: Fri, 19 Jun 2009 20:11:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Pavel Machek <pavel@ucw.cz>, James Morris <jmorris@namei.org>,
       Joseph Cihula <joseph.cihula@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, Chris Wright <chrisw@sous-sol.org>,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
Message-ID: <20090619201159.35d259bb@lxorguk.ukuu.org.uk>
In-Reply-To: <33858.1245433922@turing-police.cc.vt.edu>
References: <4A299051.40405@intel.com>
	<alpine.LRH.2.00.0906121509001.14633@tundra.namei.org>
	<20090619150514.GE1389@ucw.cz>
	<33858.1245433922@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "Somebody has screwed with this kernel image, and you're not booting what you
> thought you were booting."

So I screw with your user space - you can't measure enough to make it
save you in a general setup. Too much I can hit changes each boot.

For a tiny number of very special cases that are highly controlled it has
potential uses. Some of those are evil some are ones with meaningful uses
(eg ATM machines) - although attacks there have included hardware attacks
outside the PC components too.

Personally (and I'm sure Intel disagrees with me) my bigger work is that
I can't verify that the magic block of code for tboot is correct.


