Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZDDT4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZDDT4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 15:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZDDT4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 15:56:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33304 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZDDT4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 15:56:40 -0400
Date: Mon, 30 Mar 2009 12:25:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sergio Luis <sergio@larces.uece.br>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lauro Salmito <laurosalmito@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, x86 Maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] x86: unify power/cpu_(32|64).c
Message-ID: <20090330102502.GA1430@ucw.cz>
References: <49D71EEE.30600@larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D71EEE.30600@larces.uece.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> x86: unify power/cpu_(32|64).c
> 
> This is the last unification step. Here we do remove one of the files
> and rename the left one as cpu.c, as both are now the same.
> Also update power/Makefile, telling it to build cpu.o, instead of
> cpu_(32|64).o
> 
> Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>


Whole series looks ok to me.

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
