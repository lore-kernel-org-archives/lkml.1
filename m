Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXIBBnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXIBBnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 21:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933356AbXIBBm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 21:42:58 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:24507 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247AbXIBBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 21:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gSl5OkRqKegiMNg6BRTlCi+0kQ9aC1jGq6qZttFZZCB8YwRWdNn6Pt7z3Sxfyl18h1FIcVJtUV7U0M/GfHsH1EPvZf1DgqOwdLaOh+e+LefvsTRgIaEV3jYmbfd/ROPi2F8L0VToZmbxAPyIPM9qjJACaupLQovrP30L5e2cndE=
Message-ID: <43e72e890709011842m213b590ds141deb9657b979e7@mail.gmail.com>
Date: Sat, 1 Sep 2007 21:42:54 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Constantine A. Murenin" <mureninc@gmail.com>
Subject: Re: That whole "Linux stealing our code" thing
Cc: "Jeff Garzik" <jeff@garzik.org>, "Jason Dixon" <jason@dixongroup.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk
In-Reply-To: <f34ca13c0709011839yb32f419s20c259cbaabdd132@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
	 <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
	 <46D99FB7.6030505@garzik.org>
	 <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
	 <20070901205457.GK9260@stusta.de> <20070901215225.GM9260@stusta.de>
	 <3A831845-B630-42AD-B52F-DC9EA2060BAE@dixongroup.net>
	 <46DA1315.9060002@garzik.org>
	 <f34ca13c0709011839yb32f419s20c259cbaabdd132@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/07, Constantine A. Murenin <mureninc@gmail.com> wrote:
> On 01/09/07, Jeff Garzik <jeff@garzik.org> wrote:
> > Jason Dixon wrote:
> > > Once the grantor (Reyk) releases his code under that license, it must
> > > remain.  You are free to derive work and redistribute under your
> > > license, but the original copyright and license permission remains
> > > intact.  Many other entities (Microsoft, Apple, Sun, etc) have used BSD
> > > code and have no problem understanding this.  Why is this so difficult
> > > for the Linux brain share to absorb?
> >
> > Why is it so difficult to understand dual licensing?
>
> Maybe because Reyk's code was never dual-licensed?

We asked SFLC to work with us to make sure that everyone's copyrights
were respected in the right places, and that the licenses various developers
wanted for their copyrights were implemented correctly.  The patch I sent
implements SFLC's suggestions in that regard.

  Luis
