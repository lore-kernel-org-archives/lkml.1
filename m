Return-Path: <linux-kernel-owner+w=401wt.eu-S1422954AbXBAVTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422954AbXBAVTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423018AbXBAVTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:19:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:50832 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422954AbXBAVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:19:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DMzQkKbiSjwMYhw5jV+bw3c2jYU2fhbt3t2V0gWeQI+nJoAXTUwW2FgUoHSsNC5u9cS9zdUF/KsQfqukjB9QZfo0CTcKFN4qpq++W+GyMzLm3iSmJNVhHesgTtgf3M9OjaQ5iqC8nfbQ+XU9C03eNyd8Kpn6AZWz52uYkVPFOlM=
Message-ID: <3d57814d0702011319j48e2c2b1w376436d314a4d847@mail.gmail.com>
Date: Fri, 2 Feb 2007 07:19:07 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: Mach-O loader
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAEB951D-58D6-447D-8CDE-F1F5A1FE76C5@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0701312257x1f1fc352r6aecae72c89bee3c@mail.gmail.com>
	 <CAEB951D-58D6-447D-8CDE-F1F5A1FE76C5@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Kyle Moffett <mrmacman_g4@mac.com> wrote:
> I started working on one a while ago but I ran out of time to
> dedicate to the project.  My schedule is opening up again, though, so
> I plan to start working on it again.  At this point I have most of
> the actual loader code written, the problem is that the syscalls
> between Linux and Darwin are very different and need a binary
> translation layer which is still in the concept phase at this point. :-D

I've written one before for the Boomerang[1] project.  Don't worry
about the system calls, that's not the point.  I do wonder if you can
mix Mach-O and ELF binaries in the same process however.. that would
be good.  If you like, send me the code and I'll take a look at it.

Trent

[1] http://boomerang.sourceforge.net/  I don't work on this anymore
due to work constraints.
