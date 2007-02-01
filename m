Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXBAJel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXBAJel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 04:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXBAJel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 04:34:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:63596 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422704AbXBAJek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 04:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ix27EtGG6bCYf5je+wouBVG69GqGm7bFFVw9NVWh+MG5geeL/XQglCDmKxMoG2YklQEn4SsIrVl5AJo+AafaeloLk52fDB4Qnq6Zhv6y4gMBFgeY3q3CdkinRQxqa+hFiGrrLcdqlhr8XERJbIKUmLHIfQ0/cBvzzaurUnzHJlo=
Message-ID: <3d57814d0702010134s7944b13ehd13518deafa7e38f@mail.gmail.com>
Date: Thu, 1 Feb 2007 19:34:38 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Nicolas Mailhot" <nicolas.mailhot@gmail.com>
Subject: Re: Free Linux Driver Development!
Cc: "Greg KH" <greg@kroah.com>, "Theodore Tso" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <59045.192.54.193.51.1170321748.squirrel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
	 <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>
	 <20070131234450.GB32078@kroah.com>
	 <54850.192.54.193.51.1170319212.squirrel@rousalka.dyndns.org>
	 <3d57814d0702010103m4d7c3577q35b7f5fff16a716a@mail.gmail.com>
	 <59045.192.54.193.51.1170321748.squirrel@rousalka.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Nicolas Mailhot <nicolas.mailhot@gmail.com> wrote:
> Not all of them.
> It seems it's kosher to rewrite a corp GPL driver but not a "community" one.

As I said, Greg didn't say it was rude to write a new driver without consulting
the author of an existing driver.. corp *or* community.. so who said
it was?  You can rewrite whatever you feel like rewriting.  Greg was
talking about what is polite usage of someone elses code.  In
particular, doing stuff they've specifically said they don't want you
to do with it is rude.

>From a practical standpoint it makes sense, I think: the guy who wrote
the code is often the best person to maintain it, so don't piss him
off.  If you want to rewrite it, then you would be the guy offering to
maintain it..

Trent
