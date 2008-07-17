Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYGQUec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYGQUec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758586AbYGQUeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:34:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38137 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968AbYGQUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:34:20 -0400
Message-ID: <487FACCA.5040304@firstfloor.org>
Date: Thu, 17 Jul 2008 22:34:18 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
References: <20080716214516.GA10777@basil.nowhere.org>  <200807170011.12184.rjw@sisk.pl>  <200807161633.01375.jbarnes@virtuousgeek.org>  <487EEAEB.4050009@firstfloor.org>  <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>  <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>  <487F71E8.9050705@firstfloor.org> <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com> <487FA24B.9060803@firstfloor.org> <alpine.LFD.1.10.0807171259010.2959@woody.linux-foundation.org> <alpine.LFD.1.10.0807171304220.2959@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807171304220.2959@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> It means that a person who ran my tree as of yesterday,

Ok I understand this applies to your tree because you have lots of direct users.
And also people tend to only submit patches to you which are relatively
well tested already and don't really do "raw development" in your tree.

But for people lower down the food chain that's not necessarily the
case. They usually only get some testing through -mm/linux-next
and perhaps occasionally for individual patches posted to verify
bugs. They tend to not have many people directly pulling their stuff
(and if it's someone it is some downstream developer who typically can deal
with an occasional rebase)

Anyways if you prefer I can send to you the raw development history
(with all reverts, fixups, non bisectable section etc.), but I suspect
you wouldn't really be very happy with that.

-Andi
