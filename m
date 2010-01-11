Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323Ab0AKAkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0AKAkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 19:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526Ab0AKAkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 19:40:06 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42649 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0AKAkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 19:40:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wllQFblm/EczICEC+/AyOo7z8iD4xHipADOVdhe91afIDTwGGpeI3hgQGOeYkMhNGo
         FPY252gz/AXcB3Yg0KeA/EC9DReURdFVX4VrH3lekTap9ZKLBYaQ9LpOJzSb9OXgirhW
         5ZeO6C8CnM0o4vYGjqy7t3bwzbEWTAWnojSYE=
Date: Mon, 11 Jan 2010 01:38:39 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Yan, Zheng" <yanzheng@21cn.com>
Subject: Re: [Bug #15031] bug in fs/btrfs/ordered-data.c:672
Message-ID: <20100111003839.GA6216@Pilar>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
 <omZ8aBZReyD.A.0sG.6MlSLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <omZ8aBZReyD.A.0sG.6MlSLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So 10.Jan'10 at 23:32:57 +0100, Rafael J. Wysocki wrote:
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15031
> Subject		: bug in fs/btrfs/ordered-data.c:672
> Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
> Date		: 2010-01-02 11:32 (9 days old)
> References	: http://lkml.org/lkml/2010/1/2/17
> Handled-By	: Yan, Zheng <yanzheng@21cn.com>
> Patch		: http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03686.html

I am using the patch above since Zheng pointed it out to me and the bug
no longer appears. But it is not in mainline yet.

