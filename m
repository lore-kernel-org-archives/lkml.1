Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbXCPIbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbXCPIbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXCPIbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:31:44 -0400
Received: from web52909.mail.yahoo.com ([206.190.49.19]:20153 "HELO
	web52909.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751341AbXCPIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:31:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=NdG04f1Mrk5iRHg+F7rXewepf8vPc2ghGZd2NnTLn7FMQ0mgFkhKPTEj8VseyUPPN/NzqPRy/+LKhGY8NaDUoWFIyRxMySssRDjmDGQf/gOXFqW5A8BazpJcMauAHTppfbOse7sQVF75yM62x6QEe5EjaII1nMnmOlPbRC/3uxg=;
X-YMail-OSG: qnE0v7sVM1kkxY1F5lQ5tFw1yov83X7Z7QtHOawnX7gf4LcGWhg9kf76s0svz0Bn1EgsDbzYStVePuENz1sOSFDAb7rQZSZDJJOcgEKf01MVVuk1GsdxOyv5YPig2R6bhC9t15b3WSPEEB2e6Q6XCIM_pw--
Date: Fri, 16 Mar 2007 08:31:42 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.2 - unable to handle kernel paging request - still accessing freed memory
To: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <84144f020703160023l61ef82a4yd3d64d2f4fe9f1a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <30938.71164.qm@web52909.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On 3/16/07, Greg KH <gregkh@suse.de> wrote:
> > Is there any way you can use 'git bisect' to try to track down the root
> > cause of this?
> 
> Chris, If 2.6.19 works for you, could you please do a git bisect for
> this bug? See the following URL for details:
> 
> http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt

That would take ages - the only reason I kept on plugging away with winecfg last night was because
I was fairly certain the kernel was going to "oops" eventually (which it did). But when exactly
would I be able to declare a kernel "good" during a "git bisect"?

Cheers,
Chris



		
___________________________________________________________ 
What kind of emailer are you? Find out today - get a free analysis of your email personality. Take the quiz at the Yahoo! Mail Championship. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
