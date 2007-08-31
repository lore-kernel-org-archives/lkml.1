Return-Path: <linux-kernel-owner+w=401wt.eu-S1762423AbXHaU3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762423AbXHaU3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbXHaU3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:29:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbXHaU3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:29:47 -0400
Date: Fri, 31 Aug 2007 16:28:26 -0400
From: Bill Nottingham <notting@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
Message-ID: <20070831202826.GB15707@nostromo.devel.redhat.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20070831201820.GF31970@nostromo.devel.redhat.com> <20070831132440.43f98b73.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070831132440.43f98b73.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap (randy.dunlap@oracle.com) said: 
> A diffstat would be nice.

Sure.

 linux-2.6.22.noarch/drivers/char/Kconfig    |   17 +++++++++++++++++
 linux-2.6.22.noarch/drivers/char/keyboard.c |    2 +-
 linux-2.6.22.noarch/drivers/char/sysrq.c    |    4 ++--
 linux-2.6.22.noarch/drivers/char/vt.c       |    6 +++++-
 linux-2.6.22.noarch/drivers/char/vt_ioctl.c |    2 +-
 linux-2.6.22.x86_64/include/linux/vt_kern.h |    1 +
 6 files changed, 27 insertions(+), 5 deletions(-)
       
> Please document 'default_utf8=' in Documentation/kernel-parameters.txt.

It's already documented there (existed before this patch).

Bill
