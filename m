Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYELCod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYELCod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 22:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYELCoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 22:44:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:28313 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbYELCoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 22:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ze5EywBEPgV9cr8ojnMETVTQY7VXksbH+pGR14BDnkkmb46u37cnyDsnZglqJZQMdnqv6Oj1mKbmYilTjU/18vQUEiRsHDlc5mzEqFnEDBaw6yvDsoGf0s2P6MPEfN5azgZLl9Na18TsdbFTcvgxRDFnv3XJJthJhhy4yPTFgaE=
Date: Mon, 12 May 2008 10:42:13 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <adrian.bunk@movial.fi>
Subject: Re: [Bug #10495] Voyager phys_cpu_present_map compile error
Message-ID: <20080512024213.GA2572@hacking>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.5dB.Lx1JIB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88YBFoyd1CN.A.5dB.Lx1JIB@chimera>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:04:12PM +0200, Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.25.  Please verify if it still should be listed.
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10495
>Subject		: Voyager phys_cpu_present_map compile error
>Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
>Date		: 2008-04-20 17:12 (22 days old)
>References	: http://lkml.org/lkml/2008/4/20/259
>

I think this should be fixed by James's patch [1].

1. http://lkml.org/lkml/2008/5/9/188

-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
