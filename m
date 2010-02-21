Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0BUXPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 18:15:31 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45175 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0BUXP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 18:15:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=klmgaN0xhnEx0TLiMpaGe2JGh8snu6gbLBix5RoLUsFIxkm9Ob3SZZM9nA9Lxuie3K
         4Wsd17gAOjN//lqRTAJb+qWYrSwvqMnRELfsjup9kj8Oc3+aJwattrZS4HwurH57GG/N
         hdpjebXzrzuWn4/3Nu1ieIrZ6+UVZK8z/dbOk=
Date: Mon, 22 Feb 2010 00:15:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Michael Stefaniuc <mstefani@redhat.com>
Subject: Re: [Bug #15273] Regression in ptrace (Wine) starting with
	2.6.33-rc1
Message-ID: <20100221231522.GA7625@nowhere>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera> <ClJsQB_ZlxO.A.cQG.WdagLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ClJsQB_ZlxO.A.cQG.WdagLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 10:30:15PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15273
> Subject		: Regression in ptrace (Wine) starting with 2.6.33-rc1
> Submitter	: Michael Stefaniuc <mstefani@redhat.com>
> Date		: 2010-02-11 16:21 (11 days old)
> Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/80783/
> 		  http://patchwork.kernel.org/patch/80785/



Michael tested the patches and this seems to do the trick.
I'm just waiting for Ingo to get the patches and send them
to Linus.

Thanks.

