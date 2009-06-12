Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbZFLKiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbZFLKiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933500AbZFLKhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:37:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58852 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933988AbZFLKht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:37:49 -0400
Date: Fri, 12 Jun 2009 12:37:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Magnus Damm <damm@igel.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sergio Luis <sergio@larces.uece.br>,
       Lauro Salmito <laurosalmito@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 02/19] x86: unify power/cpu_(32|64) headers
Message-ID: <20090612103742.GF18682@elf.ucw.cz>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.xE.8UYMKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S4AoGnG.A.xE.8UYMKB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 22:26:52, Rafael J. Wysocki wrote:
> From: Sergio Luis <sergio@larces.uece.br>
> 
> First step towards the unification of cpu_32.c and cpu_64.c.
> This commit unifies the headers of such files, making both
> of them use the same header files. It also remove the uneeded
> <module.h>.
> 
> Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
