Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950Ab0CON1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:27:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:61482 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964902Ab0CON1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:27:51 -0400
Message-ID: <4B9E35A1.9080609@windriver.com>
Date: Mon, 15 Mar 2010 08:26:57 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [GIT PULL] V2 kdb / early debug (1 of 2) for
 2.6.34
References: <1267420188-10227-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1267420188-10227-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2010 13:26:58.0336 (UTC) FILETIME=[30298200:01CAC443]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2010 11:09 PM, Jason Wessel wrote:
> Linus please pull the kdb-merge tree which merges the kdb front end
> into the kernel debug core for 7 architectures.
> 

Linus, what is the status of the kdb & early debug pull requests?

I had not seen anything merged yet and you listed these as requiring
further review in your -rc1 message.  Are there any questions I can
answer?

I would like to know how to proceed because there were a number of
kgdb specific fixes integrated into the first part of the kdb merge,
as well as the directory reorganization (split of the debug core and
the gdbstub).  I have several minor non-x86 kgdb fixes waiting against
the new directory structure.

Thanks,
Jason

