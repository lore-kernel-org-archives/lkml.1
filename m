Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXBFSRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXBFSRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbXBFSRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:17:02 -0500
Received: from raven.upol.cz ([158.194.120.4]:37052 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbXBFSRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:17:00 -0500
Date: Tue, 6 Feb 2007 19:25:38 +0100
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [patch 0/3, resend] scripts, kbuild updates/fixes (against 2.6.20)
Message-ID: <20070206182538.GC1160@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz> <20070206095630.707d66ef.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206095630.707d66ef.randy.dunlap@oracle.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 09:56:30AM -0800, Randy Dunlap wrote:
> On Tue, 06 Feb 2007 02:18:19 +0100 Oleg Verych wrote:
> 
> > Due to almost zer0 activity, this may be last attempt.
> 
> Are all of these patches in -mm for testing?

Nope.

Roman Zippel joined, when i've posted one of them for testing. His
comments were (only) available at that time. And they led me to better
solution as well (for option checking in particular). Nothing from him
since then.

Patch with localversion, where i assumed wrongly "localversion~is-ok" are
OK to be valid, changed to handle, what it should handle (see patched
comments).

Last one -- gawk with frieds, got strange comments about SUSv3
compliance. But, since i've posted my tests,

Message-Id: <20070203131011.GA26632@flower.upol.cz>
Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/489286>

nobody replied.

> ---
> ~Randy
____
