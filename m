Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZKQAJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZKQAJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZKQAJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:09:12 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:38246 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZKQAJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:09:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OQzrMy6llVWaO4J3hr67yitYFyCJZh7/CTmH2GGxD9Jisyx9FxG6SSy4Qu0NLvIAto
         2hkZ5Vj0tRL+c8nWlhaJ+T84fLXwvT2da9EkhRmRmtoBVrDA3nPkznNK7BtqovWX7bgE
         BQz4C/BO3ta/SHgQmZAYhS2YBcgba5xb3CVHw=
Date: Tue, 17 Nov 2009 01:09:11 +0100
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14265] ifconfig: page allocation failure. order:5,
	mode:0x8020 w/ e100
Message-ID: <20091117000911.GA2421@bizet.domek.prywatny>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera> <OWmO9uyC1hM.A.loC.CodALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OWmO9uyC1hM.A.loC.CodALB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 12:01:19AM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14265
> Subject		: ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
> Submitter	: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> Date		: 2009-09-15 12:05 (63 days old)
> References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4

Bug is still present in 2.6.32-rc7.

Thanks.
