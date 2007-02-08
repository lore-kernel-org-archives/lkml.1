Return-Path: <linux-kernel-owner+w=401wt.eu-S1945916AbXBHWFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945916AbXBHWFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945919AbXBHWFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:05:51 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:53163 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945921AbXBHWFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:05:34 -0500
Date: Thu, 8 Feb 2007 23:05:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: The who needs reviews anyways [PATCH]
Message-ID: <20070208220548.GC20400@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 10:48:51PM +0100, Roman Zippel wrote:
> Hi,
> 
> This adds the remaining changes which should have been part of the review 
> process. Oleg could have learned something in process, but who needs that 
> if wasting everyones time is so much more fun...
> 
> Sorry for the delay, but the git server were gone.
> 
> - the define command is inappropriate (it's primarily for rule 
>   definitions)
> - execute commands in the current dir as all other commands
> - .*.tmp (but not .*.null) files are also removed up by "make clean"
> - printf has other side effects, instead stop pretending we support 
>   something else than bash
> - proper quoting
> - proper indentation
> 
> bye, Roman
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

Acked as "patch reviewed and looks good".

PS. Will be unresponsive for next 12 days due to vacation.

	Sam
