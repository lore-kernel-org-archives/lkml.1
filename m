Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbYBFMbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbYBFMbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762151AbYBFMay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:30:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:65377 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763500AbYBFMax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:30:53 -0500
Message-ID: <47A9A737.1070905@windriver.com>
Date: Wed, 06 Feb 2008 06:25:27 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [Kgdb-bugreport] [PATCH] beautification of debugger_active usage
References: <47A9A4D5.4030200@siemens.com>
In-Reply-To: <47A9A4D5.4030200@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2008 12:25:28.0440 (UTC) FILETIME=[5B900F80:01C868BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Just a beautification of using debugger_active for checking the debugger
> state.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>
> ---
>  arch/x86/kernel/kgdb.c |    6 +++---
>  include/linux/kgdb.h   |    7 ++++++-
>  kernel/kgdb.c          |    8 ++++----
>  kernel/sched.c         |    7 +------
>  4 files changed, 14 insertions(+), 14 deletions(-)
>
>   
committed to:
http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=kgdb_2.6.25

Jason.
