Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYGLHH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYGLHH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYGLHHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:07:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2587 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751813AbYGLHHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:07:10 -0400
Date: Thu, 10 Jul 2008 20:23:26 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, masbock@linux.vnet.ibm.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/9] MCE: Use 64bit machine check code on 32bit
Message-ID: <20080710182325.GB13483@ucw.cz>
References: <200807041120.678642023@firstfloor.org> <20080704212033.D40551B431F@basil.firstfloor.org> <36ca99e90807050250u718fa277t2297d6436fd14c4e@mail.gmail.com> <486F44C0.8050003@firstfloor.org> <36ca99e90807050317m7160c3eaj150ceac4440752a1@mail.gmail.com> <486F531E.6030303@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486F531E.6030303@firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-07-05 12:55:26, Andi Kleen wrote:
> Bert Wesarg wrote:
> > On Sat, Jul 5, 2008 at 11:54, Andi Kleen <andi@firstfloor.org> wrote:
> >>> Is this first "n" a typo?
> >> No. The legacy machine check code that is going away is definitely
> >> supposed to be default n. This is effectively a default y for
> >> the new code.
> > I didn't mean the "default n", but the "If you're still sure you want it, say n"
> 
> Ah that's indeed not correct. Thanks.

I thought it was a nice joke ;-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
