Return-Path: <linux-kernel-owner+w=401wt.eu-S941418AbXHJQyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941418AbXHJQyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936478AbXHJQyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:54:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:50579 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935832AbXHJQym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oGXSmPu4xC0sJz2szJvCMcKLNBvI6oEcHe7etQ70aloIIddYTividgmz5rbU7AmpBuq89NM33DQ99fnbps9TWqi5sCl+qoaJrldu2CawvAvAZch+cu56hRLVneyrMfD6k3d9TBUnTsDodB0PXxkEIpoJyOcVbTTZpWMZZAcZzNw=
Message-ID: <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com>
Date: Fri, 10 Aug 2007 12:54:41 -0400
From: "Michael Chang" <thenewme91@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: CFS review
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Mike Galbraith" <efault@gmx.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708101459530.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708010439050.1817@scrub.home>
	 <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de>
	 <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
	 <20070801175004.GA17936@elte.hu>
	 <Pine.LNX.4.64.0708011955430.1817@scrub.home>
	 <20070801190556.GA1199@elte.hu>
	 <Pine.LNX.4.64.0708100037460.1817@scrub.home>
	 <20070810054948.GA5908@elte.hu>
	 <Pine.LNX.4.64.0708101459530.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Is there any reason to believe my analysis is wrong?

Not yet, but if you give Ingo what he wants (as opposed to what you're
giving him) it'll be easier for him to answer what's going wrong, and
perhaps "fix" the problem to boot.

(The scripts gives info about CPU characteristics, interrupts,
modules, etc. -- you know, all those "unknown" variables.)

And perhaps a patch to show what parts you commented out, too, so one
can tell if anything got broken (unintentionally).

-- 
Michael Chang

Please avoid sending me Word or PowerPoint attachments. Send me ODT,
RTF, or HTML instead.
See http://www.gnu.org/philosophy/no-word-attachments.html
Thank you.
