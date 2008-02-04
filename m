Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYBDSRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYBDSRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYBDSRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:17:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1794 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752790AbYBDSRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:17:31 -0500
Date: Mon, 4 Feb 2008 18:17:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
Message-ID: <20080204181721.GA8758@ucw.cz>
References: <47A2D439.9050704@kernel.org> <20080201002837.d84fc029.akpm@linux-foundation.org> <Xine.LNX.4.64.0802011941140.16283@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0802011941140.16283@us.intercode.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-01 20:07:01, James Morris wrote:
> On Fri, 1 Feb 2008, Andrew Morton wrote:
> 
> > Really?  I'd feel a lot more comfortable if yesterday's version 1 had led
> > to a stream of comments from suitably-knowledgeable kernel developers which
> > indicated that those developers had scrutinised this code from every
> > conceivable angle and had declared themselves 100% happy with it.
> 
> FWIW, I've reviewed the patch in detail a couple of times, and don't see 
> any issues with it that haven't already been raised by Serge.
> 
> You can add my reviewed-by.
> 
> I think it does need more eyes, and some time baking in -mm.  

I don't thing -mm baking helps here. People playing with -mm are not
the ones trying to hack your box.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
