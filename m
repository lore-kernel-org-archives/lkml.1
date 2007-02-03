Return-Path: <linux-kernel-owner+w=401wt.eu-S1750824AbXBCV4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750824AbXBCV4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 16:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXBCV4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 16:56:30 -0500
Received: from relay02.mail-hub.dodo.com.au ([202.136.32.45]:48526 "EHLO
	relay02.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbXBCV4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 16:56:30 -0500
From: Grant Coady <grant_lkml@dodo.com.au>
To: Willy Tarreau <wtarreau@hera.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.4.34.1
Date: Sun, 04 Feb 2007 08:56:26 +1100
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <421as2tksguff9ls9923j01t7nft0le4h6@4ax.com>
References: <20070203201045.GA29991@hera.kernel.org>
In-Reply-To: <20070203201045.GA29991@hera.kernel.org>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 20:10:45 +0000, Willy Tarreau <wtarreau@hera.kernel.org> wrote:

>Hi all,
>
>activity has been very calm for 2.4 since 2.4.34. Three minor fixes
>were pending, and I finally decided to release 2.4.34.1 with them
>instead of keeping them in the fridge. Upgrade is recommended for
>users of smbfs with unix extension, since a security fix in 2.4.34
>broke symlinks. Special thanks to Dann Frazier, Santiago Garcia
>and Grant Coady who did the boring work of tracking and fixing the
>problem.
>
>The files are located at the usual places. Please give it some time
>to sync between the servers, and preferably use ftp2.kernel.org.

Hi Willy,

Done, runs okay here ;)

Grant.
