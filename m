Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbYJPTOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbYJPTOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbYJPTOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:14:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:12725 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbYJPTOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:date:in-reply-to:message-id:user-agent
         :mime-version:content-type:from;
        b=t0jc8ZEY9wo1NCSjYX1NtXunWUQni3IUWzLfGVpm1/ljADwYqBBZrhhu3Dgr2Xl/V2
         4oBKCYZOjK63Y7SZ1T1NRLtw9DysLKajisM9xzXcuGuAtwxua7ulG+16De7NH2iz/3v8
         Cov9Extz87pjIFwmI0cs+bcnJX7usnLoyTemI=
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>
	<20081016142619.GA3756@tatooine.rebelbase.local>
	<20081016153512.GE12962@mit.edu>
Date: Thu, 16 Oct 2008 21:14:39 +0200
In-Reply-To: <20081016153512.GE12962@mit.edu> (Theodore Tso's message of "Thu,
	16 Oct 2008 11:35:12 -0400")
Message-ID: <87ej2g5p40.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Harald Arnesen <skogtun.harald@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> On Thu, Oct 16, 2008 at 04:26:19PM +0200, markus reichelt wrote:
>> Why not just keep it? It has worked so far, and from a strictly
>> end-user point of view I cannot see any advantages at all with a new
>> scheme. The ideas mentioned so far don't cut it either.
>
> I'd cast a vote for keeping it as well.  "2.6" is actually a great
> marker so that people know that it's highly likely the version number
> is for the Linux kernel.  Contrast "I'm running 2.6.27" versus "I'm
> running 27" (huh, what does that mean?) or "I'm running the 27 kernel"
> or "I'm running Linux kernel version 27" or worse yet "I'm running
> 2008-03".  Something like "2.6.27" is just easier to say, and less
> prone to misunderstanding/confusion.
>
> Let's just leave things the way they are.

My suggestion: When 2.6.28 is released, rename it to 2.8 (or 2.8.0).
The next one will be 2.9, then 2.10 and so on. Today's 2.6.x.y will be
2.8.y.

It should minimise breakage of userspace programs.

Or wait til 2.6.30, and rename that to 3.0.
-- 
Hilsen Harald.
