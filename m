Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0CBPNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:13:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:60148 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0CBPNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:13:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PPQ0r/9CHIylOGUv7vbVV1Siz6rw8KKsLvTaNLwrLZQhVai7Zk/5yg/Lp1p1AEmyEm
         3QCTaFsXR56e0LGblfj5joYGZMmuVG4IGQTupJRAdnjJSfaZdzAkyW6NUHY8xuA6lemT
         X4eY1bqaOoZroXQIJOWFnsCucpDutspT+QXnY=
MIME-Version: 1.0
In-Reply-To: <20100301023316.GB23086@linux-sh.org>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	 <1267289508-31031-43-git-send-email-andrea.gelmini@gelma.net>
	 <20100301023316.GB23086@linux-sh.org>
Date: Tue, 2 Mar 2010 16:13:11 +0100
X-Google-Sender-Auth: 718d2b274871f915
Message-ID: <9cdbb57f1003020713x4e897af9ka87e348bf782f380@mail.gmail.com>
Subject: Re: [PATCH 42/66] arch/mips/lib/libgcc.h: Checkpatch cleanup
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/1 Paul Mundt <lethal@linux-sh.org>:
Hi Paul,
   thanks for your reply.

> I'll apply the sh part by itself, and I suppose Ralf will do the same for
> MIPS. I'm a bit confused as to why these were lumped together when 65 out
> of 66 oneliner patches made no use of ad-hoc grouping.

After the experience with GregKH, I was looking for others maintainer
interested in code cleanup. So I sent some patches over random files.
If you care, I can checkpatch.pl all mips subtree and send you patches (if any).

Thanks a lot for your work,
Andrea
