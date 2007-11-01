Return-Path: <linux-kernel-owner+w=401wt.eu-S1757693AbXKARUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbXKARUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXKARU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:20:28 -0400
Received: from helios.cs.csubak.edu ([136.168.201.112]:41952 "EHLO
	helios.cs.csubak.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbXKARU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:20:27 -0400
Date: Thu, 1 Nov 2007 10:20:24 -0700 (PDT)
From: David Griffith <dgriffi@cs.csubak.edu>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: fixing usb-midi device support
In-Reply-To: <35fbaa3e0711010346y5963d929w5054fabad1569d66@mail.gmail.com>
Message-ID: <Pine.GSO.4.55.0711011018360.13024@helios.cs.csubak.edu>
References: <Pine.GSO.4.55.0710311423530.10148@helios.cs.csubak.edu>
 <35fbaa3e0711010346y5963d929w5054fabad1569d66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.1 (/)
X-Spam-Report: ---- Start Spam Filter Report
	Filter Analysis score is (-0.1/5.0)
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-0.1 AWL                    AWL: From: address is in the auto white-list
	---- End Spam Filter results
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Vitaliy Ivanov wrote:

> David,
>
> On 10/31/07, David Griffith <dgriffi@cs.csubak.edu> wrote:
> >
> > I have a MOTU Fastlane and an Emu Xmidi 2x2 USB midi interfaces.  The Emu
> > unit works fine with current kernels.  The MOTU unit won't work with
> > kernels newer than 2.6.17.  I stumbled over a patch that had something to
> > do with a MOTU Fastlane, but I haven't been able to find it again.  Could
> > I get some advice on fixing MOTU Fastlane support?
>
> I can see that you already had a discussion on this issue:
> http://lkml.org/lkml/2007/8/10/102
>
> Any results? Do you still can see the oops?

The oops is still present.  I was hoping that the patch I found and lost
would help me understand what was going on.

-- 
David Griffith
dgriffi@cs.csubak.edu
