Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbXEXMcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbXEXMcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbXEXMbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:31:55 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:38783 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbXEXMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:31:54 -0400
Message-ID: <4655856E.4040603@gentoo.org>
Date: Thu, 24 May 2007 08:30:38 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ben Collins <bcollins@ubuntu.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5/6] SUNHME: Workaround ancient hang on U1's
References: <98cd38b5.git.bcollins@ubuntu.com> <91fcd7d6a83321c37f6769164b1b41ce78a07bfa.1179964369.git.bcollins@ubuntu.com>
In-Reply-To: <91fcd7d6a83321c37f6769164b1b41ce78a07bfa.1179964369.git.bcollins@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Collins wrote:
> This work around has been in use by almost any distribution trying to
> support sparc64 since at least 2002. Without it, sunhme hangs fairly
> quickly on UltraSPARC 1's.
> 
> Dave, I know it's not in the kernel because it isn't a "fix", but given
> that we haven't seen a fix in more than 5 years, can we get this out of my
> tree please? :)

Are you sure it is still needed? Gentoo dropped this a few months ago 
and have no regression reports.

http://www.mail-archive.com/sparclinux@vger.kernel.org/msg00418.html

Daniel

