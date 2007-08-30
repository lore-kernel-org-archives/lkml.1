Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbXH3NU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbXH3NU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXH3NUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:20:15 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:32803 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbXH3NUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:20:13 -0400
Message-ID: <46D6C40A.9090504@davidnewall.com>
Date: Thu, 30 Aug 2007 22:50:10 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>	<20070828230459.GA15937@infradead.org>	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>	<46D4CC81.4060400@zytor.com>	<m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>	<20070829114604.242b976c@the-village.bc.nu> <m1absa5kid.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1absa5kid.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> This isn't "Oh some apps are using it let's get them to stop, because
> it is inconvenient".  This is  "No apps seems to be using this, we
> keep goofing up the maintenance and no one notices, and so it is
> likely a source of security problems and other nasties"
>   

This first claim is not consistent with the next claim:

> I have evidence that there are 1 or 2 open source applications using
> this (not counting the glibc weirdness).

If may be unmaintainable but, apparently, it's not really unused.
