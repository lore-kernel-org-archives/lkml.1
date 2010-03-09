Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0CIRxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:53:37 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41646 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab0CIRxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:53:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ma++/I+ZTMOTFzDNmHNtTUuK+h/Zvx/Mek2wFT+Yoj/83M1U0HeeQqM7y/HUUFJ3BH
         i5+n0wkuuvNQDMiSOvFS4qMST2qcM+eRIsKHdw2vVl2f1c0uDtO9lXHMldSg+uPLJyCO
         ATKM5WG6Yj6Q19Y/LwfPu9+2cynuI8eONptLk=
Date: Tue, 9 Mar 2010 09:53:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Cory Maccarrone <darkstar6262@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
Message-ID: <20100309175320.GC23378@core.coreip.homeip.net>
References: <20100301080342.GH765@core.coreip.homeip.net>
 <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com>
 <6cb013311003090815o7ec1de7fna68150e469855ce5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6cb013311003090815o7ec1de7fna68150e469855ce5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 08:15:06AM -0800, Cory Maccarrone wrote:
> On Tue, Mar 9, 2010 at 6:44 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> > On Mon, Mar 1, 2010 at 03:03, Dmitry Torokhov wrote:
> >> Hi Linus,
> >>
> >> Please pull from:
> >>
> >>        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> >> or
> >>        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> >>
> >> to receive first round of updates for the input subsystem.
> >
> > i'm trying to figure out what the problem is with the ADXL34x and
> > AD714x drivers you seem to have accepted (at least, you didnt say
> > there was anything left for us to do).  i would have expected them to
> > be in 2.6.33/2.6.34 already, but it seems they arent moving now.  so
> > what's up ?
> > -mike
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-input" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> I'm in the same boat with my TSC2046 driver.  Any idea why this hasn't
> moved?  I have received no comments, nor has the driver been included
> / accepted.  Do I need to make revisions, or can it be included?
> 

I am yet to review the driver (usual time constraints, unfortunately).
Very sorry about it.

-- 
Dmitry
