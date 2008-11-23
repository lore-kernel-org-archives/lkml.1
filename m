Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYKWIGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYKWIGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYKWIGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:06:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:34308 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYKWIGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:06:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WzonGoefEfIqqmsbS9CmsNggFYhJqx49bqVIgn0F6Nvf1s/80kpNRKWOgMsqTeqOco
         6ZhlPYpdYFoVHfgNkYEkiirne5wsqaNFGqCxaZpw0fuMu+URZXmQlyKKwC0YmeOE+avi
         g15UD02AOeam4EdKiUndn7e/NzdKWxaX3US/E=
Date: Sun, 23 Nov 2008 11:06:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
Message-ID: <20081123080602.GA7855@localhost>
References: <0kQZaQnNVIL.A.BhG.FwIKJB@chimera> <V2w_GS-X2aE.A.PwH.jxIKJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <V2w_GS-X2aE.A.PwH.jxIKJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rafael J. Wysocki - Sat, Nov 22, 2008 at 09:59:19PM +0100]
| This message has been generated automatically as a part of a report
| of regressions introduced between 2.6.26 and 2.6.27.
| 
| The following bug entry is on the current list of known regressions
| introduced between 2.6.26 and 2.6.27.  Please verify if it still should
| be listed and let me know (either way).
| 
| 
| Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
| Subject		: kernel panic: softlockup in tick_periodic() ???
| Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
| Date		: 2008-09-11 16:46 (73 days old)
| References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
| Handled-By	: Thomas Gleixner <tglx@linutronix.de>
| 		  Cyrill Gorcunov <gorcunov@gmail.com>
| 		  Ingo Molnar <mingo@elte.hu>
| 		  Cyrill Gorcunov <gorcunov@gmail.com>
| 
| 

Hi Rafael, it's still there. Joshua is collecting data.

		- Cyrill -
