Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZJZUEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZJZUEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbZJZUEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:04:40 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45796 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZJZUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:04:39 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 16:04:38 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eVey8y3zugZObMu5xkrtjC8OtexCaQ+eLan/TuFkyRu9rbhSGaedL11SuenZc0vNyw
         7gAbLyLmgk6Fr3/Al6kD+NGxzDBc13yvblRfTe3ybj9dBymQwkn/ELKtu63sQmv9VnaO
         +L+bSGK6fsWF0K4c7RjF5RoUzoy+CwHMqp5GM=
Date: Mon, 26 Oct 2009 20:56:43 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       reinette chatre <reinette.chatre@intel.com>
Subject: Re: [Bug #14381] iwlagn lost connection after s2ram (with warnings)
Message-ID: <20091026195643.GA32404@Pilar.aei.mpg.de>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
 <6dRYo8ss7vL.A.EmG.hre5KB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dRYo8ss7vL.A.EmG.hre5KB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26.Oct'09 at 19:55:54 +0100, Rafael J. Wysocki wrote:
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14381
> Subject		: iwlagn lost connection after s2ram (with warnings)
> Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
> Date		: 2009-10-07 14:20 (20 days old)
> References	: http://marc.info/?l=linux-kernel&m=125492569119947&w=4

Somehow this problem did not happen again for 2 weeks or so (ie since
a few days after I reported it) and I suspend to RAM around ~4 times
a day. 

The problem was not deterministic, so I am not sure if we should close it now.
But in case you close it, I can report again if it happens in the future.
