Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYCZPyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYCZPyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbYCZPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:53:46 -0400
Received: from sacred.ru ([62.205.161.221]:36719 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759573AbYCZPxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:53:45 -0400
Message-ID: <47EA6FFF.8050000@openvz.org>
Date: Wed, 26 Mar 2008 18:47:11 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <morgan@kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz> <20080324230458.GA173@tv-sign.ru> <1206446637.3302.134.camel@moss-spartans.epoch.ncsc.mil> <20080325134001.GB5984@sergelap.austin.rr.com> <1206455835.3302.185.camel@moss-spartans.epoch.ncsc.mil> <20080325180611.GB19176@sergelap.ibm.com>
In-Reply-To: <20080325180611.GB19176@sergelap.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 26 Mar 2008 18:47:03 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

> Herbert, Pavel, do you have objections to allowing ptrace of init?
> (I believe Eric has already Acked the idea iirc?)

I 100% agree with the patch. 

And I always say this to Oleg about all his patches :)

> thanks,
> -serge
> 

