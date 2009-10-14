Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZJNA0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZJNA0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760491AbZJNA0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:26:13 -0400
Received: from mail.tpi.com ([70.99.223.143]:1082 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbZJNA0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:26:13 -0400
Message-ID: <4AD51A7C.9060207@canonical.com>
Date: Tue, 13 Oct 2009 18:25:32 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>, Greg KH <greg@kroah.com>
Subject: Re: Stable compat-wireless 2.6.32-rc4 released
References: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com>
In-Reply-To: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> As the kernel moves along so does the automatic stable backports for
> the wireless subsystem [1]. We are now on 2.6.32-rc4. Besides getting
> the same fixes from rc1..rc4 some backport changes were made as well,
> most importantly that of relying on your own kernel's iw_handler.h.
> I've tested this release with 2.6.28.
> 
> Please report any issues you see.
> 
> [1] http://wireless.kernel.org/en/users/Download/stable
> 
> PS. If you maintain a distribution and rely on stable compat-wireless
> releases please let me know so I can CC you when further updates are
> made.
> 
>   Luis
> 

Speaking as a distro, what advantage does the stable wireless backport 
offer for the currently released kernel if we are already consumers of 
stable updates?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
