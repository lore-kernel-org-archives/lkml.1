Return-Path: <linux-kernel-owner+w=401wt.eu-S1751241AbXBUMnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbXBUMnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXBUMnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:43:52 -0500
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:24585 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751241AbXBUMnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:43:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zzxbLYULA2dEBYuGixg1Wm0nH+m8+A0mBwQsXKcFqZM7q5jrFqx3OJuhgWxffnrUmO3Tp1sc1qnOjG5YCzbv30RdxzdFUAzsMJ2MzosziV4wlo1uTMBGrhlj4neVmW+BwEoI3wRbJaBNevPPWNkTpcsDVFTfJsXaVRyQV+/GMPc=  ;
X-YMail-OSG: ROm0r1gVM1m8dcIFR4j0YPLrGdiZIWhb.od6FYrCJLJHzJaO92vqL62YE9mE5PalBfKOLk85v5iw5IWAsJuzhV7lMiTIQXd4mKS735ep20f5ZJ_2VnhwY3_V3GHsb91x5zKPl3Q4OJhC
From: Blaisorblade <blaisorblade@yahoo.it>
To: gregkh@suse.de, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: patch x86_64-fix-2.6.18-regression-ptrace_oldsetoptions-should-be-accepted.patch queued to -stable tree
Date: Wed, 21 Feb 2007 13:43:42 +0100
User-Agent: KMail/1.9.5
Cc: ak@suse.de, akpm@osdl.org, jdike@addtoit.com, stable@kernel.org
References: <20070220234253.7B612C15B05@imap.suse.de>
In-Reply-To: <20070220234253.7B612C15B05@imap.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702211343.43112.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 00:41, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
>
>      Subject: x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should
> be accepted
>
> to the 2.6.18-stable tree.  Its filename is

Since you are still maintaining 2.6.18, I've just sent another patch for that, 
i.e. the backport of commit 14679eb3c50897889ba62f9a37e3bcd8a205b5e7.
Could you still merge it in this release, especially since this is the last 
2.6.18-stable you are doing?
Also, this patch should also be merged in 2.6.20, but I saw no mail about 
this, so I wanted to make sure it's heading there too.

> x86_64-fix-2.6.18-regression-ptrace_oldsetoptions-should-be-accepted.patch
>
> A git repo of this tree can be found at
>    
> http://www.kernel.org/git/?p=linux/kernel/git/gregkh/stable-queue.git;a=sum
>mary

Hmm, this should be (note the missing gregkh in the path):
http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
