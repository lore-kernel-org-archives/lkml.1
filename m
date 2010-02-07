Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab0BGFL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 00:11:26 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:50389 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751118Ab0BGFLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 00:11:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkBAPfZbUtLd/sX/2dsb2JhbAAIgyrFUo8ZgS+CSlsE
X-IronPort-AV: E=Sophos;i="4.49,420,1262581200"; 
   d="scan'208";a="55478731"
Message-ID: <4B6E4B7B.9010201@teksavvy.com>
Date: Sun, 07 Feb 2010 00:11:23 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain> <4B6E4793.3010201@teksavvy.com> <20100207045844.GS24051@bombadil.infradead.org>
In-Reply-To: <20100207045844.GS24051@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Sat, Feb 06, 2010 at 11:54:43PM -0500, Mark Lord wrote:
>> I just wish the GNU tar folk had the sense to combine -z and -j
>> into a single flag.
..
> Shouldn't be needed anymore...
..

Ouch.  'tar xf' does indeed seem to work.
But I've got nearly 20 years of habit now in 'tar xzf',
and 'z' still fails on .bz2 files.  Damn!  ;)
