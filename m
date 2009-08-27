Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbZH0Mkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbZH0Mkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZH0Mks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:40:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZH0Mks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:40:48 -0400
From: Andreas Schwab <schwab@redhat.com>
To: heitkamp@ameritech.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: popen2 popen call
References: <alpine.DEB.1.10.0908270803540.3447@pc1lin.fred.org>
X-Yow: ...Just enough time to do my LIBERACE impression...
Date: Thu, 27 Aug 2009 14:40:45 +0200
In-Reply-To: <alpine.DEB.1.10.0908270803540.3447@pc1lin.fred.org>
	(F. Heitkamp's message of "Thu, 27 Aug 2009 08:12:31 -0400 (EDT)")
Message-ID: <m3prahctv6.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"F. Heitkamp" <heitkamp@ameritech.net> writes:

> When the popen call is made in sshd/session.c I get a error from
> strerror of "Function not Implemented".

Which function exactly returns this error?

> I googled a bit and found that there is sometimes an problem between
> the way the kernel and glibc are compiled that causes glibc not to
> find the popen2 call in the kernel.

There is no such thing as a popen2 syscall.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
