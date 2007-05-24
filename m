Return-Path: <linux-kernel-owner+w=401wt.eu-S1751302AbXEXQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbXEXQ2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbXEXQ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:28:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:63807 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbXEXQ23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t0UsB2V4G0FWDIb3oMHHQG7AEvgSuhnEGwXqNhEAsAPlx9JYv3kVtP3do2VIvise31AtBNZFLt/JndftH5Sjle1uJHRtUN31xP+UayhgQ44nyMXpFjzH1kRiksCLDvbadlG7z4da7RHm18pgNSD9FZLEBaVLKzf9XGAtc+377FE=
Message-ID: <f24d23310705240928g13dbd516q1affff05da7a44ec@mail.gmail.com>
Date: Thu, 24 May 2007 21:58:27 +0530
From: "debian developer" <debiandev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH - 1/1] Documentation/HOWTO
In-Reply-To: <alpine.LFD.0.98.0705240847160.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f24d23310705180629x50c56ayfdcde357f0373fc4@mail.gmail.com>
	 <Pine.LNX.4.64.0705181200440.18186@localhost.localdomain>
	 <10867.1179509181@turing-police.cc.vt.edu>
	 <2cd57c900705240245s5448257ape203deade7812121@mail.gmail.com>
	 <20070524135633.53260eb3.diegocg@gmail.com>
	 <alpine.LFD.0.98.0705240847160.26602@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sept. 2006! its been there since quite a long time.
now what happens to my patch submitted to Greg???

On 5/24/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 24 May 2007, Diego Calleja wrote:
> > El Thu, 24 May 2007 17:45:04 +0800, "Qi Yong" <qiyong@fc-cn.com> escribió:
> >
> > D'oh, it seems the patch was picked from the mailing list and merged twice,
> > and I didn't notice it.
> >
> > > Torvalds, Care to revert one commit?
> >
> > Agreed, one of them can be removed.
>
> Yes, done.
>
> Andrew - can you check that it's also removed from your queues, since it
> might be there still just because it keeps applying cleanly.
>
> You might have it described as "HOWTO: mention bughunting" rather than
> "HOWTO: bug report addition".
>
>                 Linus
