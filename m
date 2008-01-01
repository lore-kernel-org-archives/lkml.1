Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbYAAX6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbYAAX6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbYAAX6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:58:08 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:52156 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755331AbYAAX6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:58:06 -0500
Message-ID: <477AD38C.6030206@nigel.suspend2.net>
Date: Wed, 02 Jan 2008 10:58:04 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Christian Hesse <mail@earthworm.de>
CC: suspend2-devel@lists.tuxonice.net,
       "The place to get help!" <suspend2-users@lists.tuxonice.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Suspend2-devel] Reboot problem
References: <477AC060.5040004@nigel.suspend2.net> <200801020030.06940.mail@earthworm.de>
In-Reply-To: <200801020030.06940.mail@earthworm.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian.

Christian Hesse wrote:
> On Tuesday 01 January 2008, Nigel Cunningham wrote:
>> Third, regarding the patch itself, I'm taking my time in working towards
>> the 3.0 release. We don't have any major bugs with 3.0-rc3 reported [...].
> 
> Well, I think I still have a bug, though it is possibly a mainline problem and 
> it's not a showstopper. After a suspend/resume cycle the reboot does not 
> work. The system hangs with "Rebooting system" (or similar). After that you 
> have to hard reset the system, which is not really a problem as filesystems 
> have been unmounted before. Reboot without a suspend cycle before and halt 
> with and without suspend cycle work without problems.

Just to clarify, do you mean rebooting after writing an image, or
shutting down and rebooting? It could be that there's some change to the
semantics in 2.6.24 that I haven't noticed yet.

> I'm using toi 3.0-rc3 with kernel 2.6.24-rc6 and beside the problem described 
> above I'm really happy with toi.
> 
> Happy new your to everybody!

And to you too!

Nigel
