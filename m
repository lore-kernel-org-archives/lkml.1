Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbZDCPfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbZDCPfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbZDCPfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:35:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39468 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759701AbZDCPfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:35:36 -0400
Date: Fri, 3 Apr 2009 16:35:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LANANA: Change of management and resync
Message-ID: <20090403163534.4853af86@lxorguk.ukuu.org.uk>
In-Reply-To: <874ox5lps1.fsf@basil.nowhere.org>
References: <20090403135051.19177.23019.stgit@localhost.localdomain>
	<874ox5lps1.fsf@basil.nowhere.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Apr 2009 17:29:02 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> > @@ -340,7 +345,7 @@ Your cooperation is appreciated.
> >  		 14 = /dev/touchscreen/ucb1x00  UCB 1x00 touchscreen
> >  		 15 = /dev/touchscreen/mk712	MK712 touchscreen
> >  		128 = /dev/beep		Fancy beep device
> > -		129 = /dev/modreq	Kernel module load request {2.6}
> > +		129 = 
> 
> You drop a lot of entries like this. Was that intended?

Yes - those are ones that were obsolete well before 2.6. I left the
blanks in so it is clear where the gaps are for re-use.

