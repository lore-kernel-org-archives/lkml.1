Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZF3JQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZF3JQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZF3JQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:16:26 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:34061 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZF3JQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MwZ1kPtmtgp+Kvq+Owj1GBw7yuYXpnk2F7aqtNf8zaUv3TAn/zaLXsUNOhZrvWQe0M
         3GS4iW6BIbr7671lMZVu2sh6U3ZFQCAwbcbbW/af9pPYlkofn4cQXlew12C10qoVPUIF
         4d7t1zgNw81ww8dU/qOiWz1qm/i0bYg9o8f2g=
Date: Tue, 30 Jun 2009 17:18:35 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] kbuild: finally remove the obsolete variable $TOPDIR
Message-ID: <20090630091835.GC5873@cr0.nay.redhat.com>
References: <20090619074241.6646.42298.sendpatchset@localhost.localdomain> <20090630090639.GA5873@cr0.nay.redhat.com> <20090630091638.GA12926@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630091638.GA12926@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 11:16:38AM +0200, Sam Ravnborg wrote:
>On Tue, Jun 30, 2009 at 05:06:39PM +0800, Amerigo Wang wrote:
>> On Fri, Jun 19, 2009 at 03:40:26AM -0400, Amerigo Wang wrote:
>> >
>> >TOPDIR is obsolete, it can be finally removed now.
>> >
>> >Signed-off-by: WANG Cong <amwang@redhat.com>
>> >Cc: Sam <sam@ravnborg.org>
>> 
>> ping Sam...
>http://git.kernel.org/?p=linux/kernel/git/sam/kbuild-fixes.git;a=commit;h=112942353992d95099fb5b71c679ff1046fccfcf
>
>Seems I forgot to send you an "applied" mail.
>

No problem. Thanks!

