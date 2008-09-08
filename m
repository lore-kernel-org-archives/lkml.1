Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYIHNyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYIHNyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYIHNyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:54:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43297 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYIHNyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:54:38 -0400
Date: Mon, 8 Sep 2008 15:55:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tony Vroon <tony@vroon.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
Message-ID: <20080908135558.GA31784@elf.ucw.cz>
References: <1220754742.8530.12.camel@localhost> <87abeivrdf.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abeivrdf.fsf@basil.nowhere.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-09-08 12:55:40, Andi Kleen wrote:
> Tony Vroon <tony@vroon.org> writes:
> 
> > HARDWARE ERROR. This is *NOT* a software problem!
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Please contact your hardware vendor
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> > I realize that the linux kernel may be entirely blameless in this
> > situation,
> 
> It is, like mcelog told you.

Ugh, actually this is not right. AFAIK MCEs can be triggered by stuff
like PCI aborts, which in turn can be caused by software.

If you really want me to contact hw vendor, you need to be a lot more
specific.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
