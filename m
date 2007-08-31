Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbXHaUez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbXHaUez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760154AbXHaUer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:34:47 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46904 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759811AbXHaUer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:34:47 -0400
Message-ID: <46D87B26.5060608@oracle.com>
Date: Fri, 31 Aug 2007 13:33:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
References: <20070831201820.GF31970@nostromo.devel.redhat.com> <20070831132440.43f98b73.randy.dunlap@oracle.com> <20070831202826.GB15707@nostromo.devel.redhat.com>
In-Reply-To: <20070831202826.GB15707@nostromo.devel.redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Nottingham wrote:
> Randy Dunlap (randy.dunlap@oracle.com) said: 
>> A diffstat would be nice.
> 
> Sure.
> 
>  linux-2.6.22.noarch/drivers/char/Kconfig    |   17 +++++++++++++++++
>  linux-2.6.22.noarch/drivers/char/keyboard.c |    2 +-
>  linux-2.6.22.noarch/drivers/char/sysrq.c    |    4 ++--
>  linux-2.6.22.noarch/drivers/char/vt.c       |    6 +++++-
>  linux-2.6.22.noarch/drivers/char/vt_ioctl.c |    2 +-
>  linux-2.6.22.x86_64/include/linux/vt_kern.h |    1 +
>  6 files changed, 27 insertions(+), 5 deletions(-)
>        
>> Please document 'default_utf8=' in Documentation/kernel-parameters.txt.
> 
> It's already documented there (existed before this patch).

Great :)

Thanks.
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
