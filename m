Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZGHPNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZGHPNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZGHPNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:13:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37018 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZGHPNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:13:38 -0400
Date: Wed, 8 Jul 2009 11:12:58 -0400
From: Bill Nottingham <notting@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Peter Jones <pjones@redhat.com>, Dave Airlie <airlied@gmail.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
Message-ID: <20090708151258.GA30765@nostromo.devel.redhat.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>, Peter Jones <pjones@redhat.com>,
	Dave Airlie <airlied@gmail.com>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Scott James Remnant <scott@canonical.com>,
	Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com> <20090623144221.GA29593@suse.de> <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com> <20090623153928.GA32604@suse.de> <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com> <4A54A4A6.2060100@redhat.com> <4A54A538.3080407@redhat.com> <20090708140419.GA20418@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708140419.GA20418@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH (gregkh@suse.de) said: 
> > So that could be related to what you're seeing.
> 
> That file is now available in /sys/kernel/debug/usb/devices if you
> really need it.

How is a deprecated-but-stable filesystem ABI better than a guaranteed-to-
not-be-stable debugfs ABI?

Bill
