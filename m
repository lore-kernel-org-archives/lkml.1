Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848Ab0AVCZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0AVCZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802Ab0AVCZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:25:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:18021 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0AVCZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:25:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qCPrpPRJpUlFCNr1NtN/19JefRXP6auM1iWMSMkAcrMRXDYns3LNEZf9v8M0na2chx
         gmK/rfY4BMGez09ct50/T9oR9CjEHityUDw7B5o1F3+Ar5Ujbg9RCQJGna4PPi2tk0tA
         0Uod0wnyzWtUwayO7V9WDe6D5pDjaPVx3BOrE=
MIME-Version: 1.0
In-Reply-To: <5c7d4fb81001211800k2bf2025bqea45a78292da2199@mail.gmail.com>
References: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
	 <5c7d4fb81001211800k2bf2025bqea45a78292da2199@mail.gmail.com>
Date: Fri, 22 Jan 2010 10:25:07 +0800
Message-ID: <2375c9f91001211825q2059327dy32a1093f31a69b62@mail.gmail.com>
Subject: Re: Hi all, bug or design flaw?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Shu Wu <superwushu@gmail.com>
Cc: Stepan Chatalyan <kehcho@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 10:00 AM, Shu Wu <superwushu@gmail.com> wrote:
> Hey, buddy, this is not the right place to raise a user-space
> question. But as for your question, you'd better to learn what the "."
> means. "#!/bin/bash" is used to indicate in shell when executed, while
> to be just a comment in the latter.
>

"." equals to "source", which means sourcing a file, it is the shell
which he is using does this, which is always available by executing
"echo $0" from command line. Yes, shebang is used when executing.
