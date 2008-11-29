Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYK2Ukp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYK2Ukp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 15:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYK2Ukg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 15:40:36 -0500
Received: from metal.x2a.org ([206.248.189.157]:55836 "EHLO metal.x2a.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYK2Ukf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 15:40:35 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Nov 2008 15:40:35 EST
Message-ID: <4931A6DA.2070007@x2a.org>
Date: Sat, 29 Nov 2008 15:32:26 -0500
From: Jonathan Bastien-Filiatrault <joe@x2a.org>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Andres Freund <andres@anarazel.de>
CC: Theodore Tso <tytso@mit.edu>, adilger@sun.com,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: EXT4 ENOSPC Bug
References: <200811291418.24672.andres@anarazel.de>
In-Reply-To: <200811291418.24672.andres@anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Freund wrote:
> Hi Ted, Hi Andreas, hi all,
>
> On a testsystem (spare laptop) with ext4 as root filesystem sometimes the
> system starts to return ENOSPC to all write/create syscalls.
> Sometimes the system runs without problems, at other times it starts
having
> problems soon after boot.
> A reboot resolves the problem temporarily.
I have had the same problem.
>
> I don't see  a specific usage triggering the problem.
Using Vuze(formerly azureus) seemed to trigger the problem. My system
can run fine for days before it happens.
>
> Deleting some files sometimes allows the creation (just touch
$unused_filename)
> of some files, but not many.
>
> Anything I can do to help you to debug the problem?
>
> Andres
I do not have much more info to give you, this is mostly a "me too".

Thanks,
Jonathan
