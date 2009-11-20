Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZKTNOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZKTNOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZKTNOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:14:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54719 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZKTNON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:14:13 -0500
Date: Fri, 20 Nov 2009 08:14:00 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jiri Slaby <jslaby@novell.com>
Cc: jirislaby@gmail.com, mingo@elte.hu, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 13/16] core: implement getprlimit and setprlimit
	syscalls
Message-ID: <20091120131400.GA21197@hmsreliant.think-freely.org>
References: <4B040A03.2020508@gmail.com> <1258555922-2064-13-git-send-email-jslaby@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258555922-2064-13-git-send-email-jslaby@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.6 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 03:51:59PM +0100, Jiri Slaby wrote:
> This patch adds the code to support the sys_setprlimit and set_getprlimit
> syscalls which modify the rlim values of a selected process.
> 
> Based on Neil's work. Thank him.
> 
> Signed-off-by: Jiri Slaby <jslaby@novell.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---

Looks good, thanks.
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
