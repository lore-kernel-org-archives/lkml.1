Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZBVKWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZBVKWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 05:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZBVKWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 05:22:30 -0500
Received: from bay0-omc3-s4.bay0.hotmail.com ([65.54.246.204]:24842 "EHLO
	bay0-omc3-s4.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764AbZBVKWa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 05:22:30 -0500
Message-ID: <BAY108-W2C10388371126DA9B254C9DB10@phx.gbl>
X-Originating-IP: [83.226.131.50]
From: Richard Jonsson <richard_jonsson@hotmail.com>
To: <lsorense@csclub.uwaterloo.ca>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: RE: Unable to write dvd+r on 3 systems
Date: Sun, 22 Feb 2009 11:22:29 +0100
Importance: Normal
In-Reply-To: <20090220170234.GA7314@csclub.uwaterloo.ca>
References: <BAY108-W33A90CE987FE494CAA66779DB90@phx.gbl>
 <20090220170234.GA7314@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Feb 2009 10:22:29.0537 (UTC) FILETIME=[77315110:01C994D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Is anything stupid like gnome volume manager or hal or something regularly
> poking at the drive to detect discs?
>
They are present on system1, but not the other two. How can I determine if
they interfere?

> Are you using 80conductor IDE cables (for those drives that are IDE)?
> I have had some DVD writers fail in odd ways when using 40conductor
> cables.
>
Yes.

Running "dd if=/dev/dvd of=/dev/null" on a burned disc reports read
error at or around the block where the speed jumps from 2.4x> 4.0x or
from 4.0x> 6.0x. 
I had logs for this, but misplaced them =/. Also when jumping to
the next higher speed there is a dip where growisofs reports 0x burn
speed, is that normal?

> --
> Len Sorensen

_________________________________________________________________
Hitta bästa priserna på MSN Shopping!
http://shopping.msn.se/co_16199-msn-shopping.html