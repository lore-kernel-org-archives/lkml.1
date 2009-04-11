Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZDKDmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZDKDmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 23:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbZDKDmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 23:42:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:10904 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbZDKDmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 23:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gLZ1Jp5593/wW1Wqw3CH5sfq95skIjI7XAgFprLPliW26WR43/Os60sbVOYSGHhvcY
         Nkdr6usSOtpCO19O9bjDqBmhL/Eo+97/yfvCtS/GV9x7OxD1CajHCDsgNJBMBBKporvn
         KqUNbzkhsTrHaDu+S4n6v5xPR85wZY0kCUq/Y=
MIME-Version: 1.0
In-Reply-To: <20090410192529.GA25551@uranus.ravnborg.org>
References: <19057.1239370935@redhat.com>
	 <20090410192529.GA25551@uranus.ravnborg.org>
Date: Sat, 11 Apr 2009 11:42:01 +0800
Message-ID: <df9815e70904102042r2cd2e3e3ue6159f348e4c192e@mail.gmail.com>
Subject: Re: [GIT PULL] MN10300: Move arch headers to arch dir
From: Jike Song <albcamus@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, torvalds@osdl.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 3:25 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> .gitignore is left in include/asm-mn10300.
>
> As the content of that file is obsoleted by your last patch it can safely be deleted.
> Linus - can I ask you to do so?
>
>        Sam

off topic: there is also a .gitignore left in include/asm-arm.


-- 
Thanks,
Jike
