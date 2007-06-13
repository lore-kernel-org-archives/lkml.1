Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbXFMWVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbXFMWVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbXFMWUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:20:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:30686 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbXFMWUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gXW+Wva/xYGM5HxZ4FkR1c7M3gJ6Xrb4doL1pbVSzamDLPkWh+3/emYpRVuDO6ESAfPp6vSjlv5pFJRyfBafyMKRcZ7U9M4DlfWIigJwNtJju1CuwVBHEUueHtNbtHZrrmKXW1xHNmJu7mI6+aReinvxxCi+0AI3CVZ3tHSQ+Ys=
Message-ID: <fa4052ef0706131520x619ff3f5ke23cf649b8ff2b79@mail.gmail.com>
Date: Wed, 13 Jun 2007 18:20:33 -0400
From: Shane <gnome42@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH RT] fix migrating softirq [cause of network hang]
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <Pine.LNX.4.58.0706131723430.20636@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0706131414o27b2281bp81d3f5b3d3104f87@mail.gmail.com>
	 <Pine.LNX.4.58.0706131723430.20636@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> > I have applied this patch to 2.6.21.4-rt13 and I think it might have
> > solved my bizarre nfs hangage issues that cropped up lately. Thanks
> > for tracking that down it was driving me nutz!
> >
> > It has only been a few hours, but if you don't hear back from me in
> > the next day or so then it's good to go IMVHO. :)
> >
>
> Hi Shane,
>
> That's great to hear!  Well, if it does go well, could you post to LKML
> and linux-rt mailing lists, as well as CC'ng Ingo. Good news like this
> should be shared ;-)
>
> Heh, even if it doesn't go well, you can post to the above too.

Heh, I spoke too soon. This patch doesn't seem to help my problem after all. :/

Shane
