Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZFYGPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZFYGPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759301AbZFYGOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:14:50 -0400
Received: from smtp4.netcologne.de ([194.8.194.137]:39977 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538AbZFYGOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:14:49 -0400
From: Mathias Kretschmer <mathias@blx4.net>
Organization: BLX4
To: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Thu, 25 Jun 2009 08:14:40 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <200906182355.57100.mathias@blx4.net> <4A42AEEC.9070002@windsormachine.com>
In-Reply-To: <4A42AEEC.9070002@windsormachine.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906250814.43337.mathias@blx4.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009 00:55:40 Mike Dresser wrote:
> Tried 2.6.30-git18 the other day, machine jammed up with the usual BUG,
> though it was on radix-tree.c:464 this time.

I gave up and went back to 2.6.28.9, as you mentioned before.

> I really should get around to putting an APC masterswitch on this
> server, since it won't reboot with anything but the power
> switch/reset(though the system is otherwise fine, interactivity is
> perfect.. just can't kill processes)

Yep, I had that happening a few days ago. The box worked fine, but won't 
reboot. Just hangs somewhere during unmount. I saw a kernel crash call trace 
somewhere, but it went by too quickly and I couldn't get it back.

-Mathias

> Mike

