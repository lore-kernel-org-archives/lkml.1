Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbXEUWJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbXEUWJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbXEUWJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:09:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756939AbXEUWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:09:25 -0400
Date: Mon, 21 May 2007 15:04:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: "Ken Chen" <kenchen@google.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kay Sievers" <kay.sievers@vrfy.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Message-Id: <20070521150409.e1ef7701.akpm@linux-foundation.org>
In-Reply-To: <200705212320.55270.uwe.bugla@gmx.de>
References: <464F42F3.1080300@madrabbit.org>
	<b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
	<b040c32a0705211348r664e37f4hf03bec6ab27a7139@mail.gmail.com>
	<200705212320.55270.uwe.bugla@gmx.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 23:20:54 +0200
Uwe Bugla <uwe.bugla@gmx.de> wrote:

> I meanwhile tried to find out why my AMD K7 machine oopses with 2.6.21.1.
> I first suspected sis5513 ide module, reverted all its dependencies, even 
> changed a Makefile, but the Oops is still there after 10 modules reverted. I 
> am standing in the dark, although I really would like to help to close down 
> 2.6.21.x "cleanly".
> 
> On Intel P 4 machines this Oops does not happen at all, only on the AMD K7 
> machine.
> Already planned to start a new thread but instead of wild guessing around I do 
> not have any idea wht the reason for the kernel Oops could be.

Yes, please send out a fresh bug report for this.
