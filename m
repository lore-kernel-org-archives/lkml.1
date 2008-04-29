Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYD2GcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYD2GcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYD2Gb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:31:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:56589 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbYD2Gb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oWS+biShgdRdf2VZQgiB1QgU9Mnm1ERQ3cQdc8Ry3ppz6dwur/lKuGm4Xo2mV1wuSqw4QFX8l86aJDV8yRjXeFM1KqoJEf2hhUHEnXB6ipxrb3SkRYUDv5UTZjyOoUSgCslpZCSKcF4/E1c1VcubmMom//n/IcaIeM9G6/SFrWg=
Message-ID: <6bc632150804282331t191abb47gec8bc2e075739a4f@mail.gmail.com>
Date: Tue, 29 Apr 2008 12:01:55 +0530
From: "pradeep singh rautela" <rautelap@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [Q]Can a file be dual licensed in upstream kernel?
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080429062627.GA3195@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bc632150804282237o1aa04e28t93f46874cd14721f@mail.gmail.com>
	 <20080429055356.GA8279@kroah.com>
	 <6bc632150804282310yf2a3bfm5a5e89e5ed4af165@mail.gmail.com>
	 <20080429062627.GA3195@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:56 AM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Tue, Apr 29, 2008 at 11:40:26AM +0530, pradeep singh rautela wrote:
>  > On Tue, Apr 29, 2008 at 11:23 AM, Greg KH <greg@kroah.com> wrote:
>  > > On Tue, Apr 29, 2008 at 11:07:37AM +0530, pradeep [snip]
>  > >  > Can a module/file be Dual licensed(i.e BSD/GPLv2) in the upstream
>  > >  > Linux kernel sources?
>  > >
>  > >  Are you somehow not believing the files that we have in the tree that
>  > >  are licensed this way?
>  > >  > I think it is GPLv2 only.
>  > >
>  > >  Licensing questions would be better off asked to lawyers, not
>  > >  programmers.  Would you ask a random group of lawyers on a public
>  > >  mailing list medical questions and trust their responses?
>  >
>  > Um... apologies Greg.I did not mean that in any sense.I am a
>  > programmer not a lawyer. I am asking to get clear understanding of the
>  > licensing issues and I myself do not have any good understanding on
>  > dual licensing Vs GPLv2 licensing in Linux kernel.
>
>  I share Greg's opinion that this list is not the place for getting or
>  giving legal advice. Please _do_ consult a lawyer.
>  In my _personal_opinion_, dual licensing gives you the right to choose
>  between two licenses. If a file is dual licensed BSD/GPLv2, anybody
>  (including yourself) is free to get rid of the BSD part and make it
>  GPLv2 only.

Thanks Hans.That clears things for a newbie like me.

Regards,
    --Pradeep
>
>  Thanks,
>  Hans
>
>



-- 
Pradeep Singh Rautela
http://eagain.wordpress.com
http://emptydomain.googlepages.com
