Return-Path: <linux-kernel-owner+w=401wt.eu-S936802AbZDIUvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936802AbZDIUvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764071AbZDIUva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:51:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:46611 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762112AbZDIUv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:51:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=ZI738j6ZMhvhQQRctT28sxDKEpZ97xLDVnn097Ll1jFQ3twuuvVvpeuEeCCc/W4fqQ
         NtX82BqTVN9ZalhjrwKd7aZxwAa2uVR2R2ZYoPlotzROFzgvgSDsZooqWH2o04KxznOk
         r8oCeAG93/aH8Q+NgjNGQW2maHqivXCDagJak=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
References: <013601c9b94f$3e73c820$bb5b5860$@com> <alpine.LFD.2.00.0904091326480.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904091326480.4583@localhost.localdomain>
Subject: RE: page corruption bug in recent kernel (2.6.29)?
Date: Thu, 9 Apr 2009 13:50:52 -0700
Message-ID: <013701c9b954$dfd54fe0$9f7fefa0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acm5U+hyBoXbIgzXSHymLwDdIdHOZwAAN3Gg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As you say that you can trigger this fairly easily, one thing that you
> could try is to bisect it down the which kernel release it starts
> happening with. And even if it's not a kernel bug, doint that may give
> hints about perhaps what kind of things trigger the behavior, and might
> help you figure out where the bug is even if it's somewhere else.

Thanks, I agree it's not necessarily kernel related. I'm in the process 
of bisecting it. Will keep you posted.

Hua

