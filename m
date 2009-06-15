Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbZFOWju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbZFOWju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZFOWjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:39:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61076 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZFOWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:39:41 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5647"; a="19453326"
From: davidb@quicinc.com
Date: Mon, 15 Jun 2009 15:39:41 -0700
To: Ben Leslie <benno@benno.id.au>
Cc: Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
       Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090615223941.GA8974@huya.quicinc.com>
Mail-Followup-To: Ben Leslie <benno@benno.id.au>,
	Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
	Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Tony Lindgren <tony@atomide.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Miller <davem@davemloft.net>,
	lkml <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk" <linux-arm-kernel@lists.arm.linux.org.uk>
References: <4A3175AC.9070100@bluewatersys.com> <alpine.LFD.2.00.0906112105220.31536@xanadu.home> <4A31AECA.6070303@bluewatersys.com> <alpine.LFD.2.00.0906112138090.31536@xanadu.home> <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com> <20090612103521.GD18682@elf.ucw.cz> <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com> <a55d774e0906130005v5a35aa60ybabde470ff44cf77@mail.gmail.com> <20090615162150.GC6842@huya.quicinc.com> <17b28da20906151525q1d8f10daj734faacf5dafda12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17b28da20906151525q1d8f10daj734faacf5dafda12@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 03:25:35PM -0700, Ben Leslie wrote:

> > The Android busybox
> > <http://benno.id.au/blog/2007/11/14/android-busybox> mostly
> > works.  The poster doesn't seem to provide source, even though
> > busybox requires modification to build for Android (although not
> > much).
> 
> I didn't need to change anything; I just compiled busybox; No changes
> required. (Note: It is a static binary that includes glibc).

I wonder if it's changed since you built it, then.  I had to hack
up a few paths since the Android environment doesn't put things
in normal places.

David
