Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbYBLViO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbYBLViO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYBLVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:37:58 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:50169 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYBLVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=thNSgRWP8CVT15q8C+PTmhXBTilV8Oj8ScDsUtt63gTSp6vBgUkrRdpwotMny0SaQz0ZRBhHx56sRhkNrQINPYfjwixxed1tX1BESVD7S3ozLVX9/AaEA0o+DId1uUJ1ouw/nvT8EzuzOzQB/r/RkWdmBNsgMmfjEUnhvJ4RGDg=
Message-ID: <170fa0d20802121337t35787cbby52286f5a08ea2e15@mail.gmail.com>
Date: Tue, 12 Feb 2008 16:37:54 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Ferenc Wagner" <wferi@niif.hu>
Subject: Re: currently active Linux kernel versions
Cc: "Xavier Bestel" <xavier.bestel@free.fr>, linux-kernel@vger.kernel.org,
       "Willy Tarreau" <w@1wt.eu>
In-Reply-To: <87wsp9q3ev.fsf@szonett.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87skzx53a9.fsf@szonett.ki.iif.hu>
	 <1202850783.6697.0.camel@bip.parateam.prv>
	 <87wsp9q3ev.fsf@szonett.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 4:18 PM, Ferenc Wagner <wferi@niif.hu> wrote:
> Xavier Bestel <xavier.bestel@free.fr> writes:
>
> > On mar, 2008-02-12 at 21:27 +0100, Wagner Ferenc wrote:
> >
> >> which are the "currently active Linux kernel versions" at any point in
> >> time?  The quote is taken from http://lkml.org/lkml/2008/2/11/29.
> >> Or more precisely: which are the "stable" versions I can depend on for
> >> a more or less critical server, those that have active security
> >> support or receive at least critical bugfixes?  I know about the
> >> 2.6.2[34].y stable git trees, but I wonder how long will those receive
> >> attention (that is, security fixes).  Can I find a written policy
> >> somewhere?
> >
> > The answer is at http://kernel.org/
>
> Not quite, at least I can't find 2.6.23.y there, even though that
> branch seems to be maintained...

2.6.16.x is still maintained (2.6.16.60 was recently released).

2.6.22.x is still maintained but Greg KH is apparently going to be
ending his duties on it after the next release or so.  There is some
confusion as to whether Willy Tarreau will be taking on the 2.6.22.x
tree once Greg is done, Willy?:
http://lwn.net/Articles/268003/
http://kerneltrap.org/Linux/Stable_2.6_Branches

2.6.23.x and 2.6.24.x are obviously quite active for stable@kernel.org
