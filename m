Return-Path: <linux-kernel-owner+w=401wt.eu-S1030368AbXBZRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030368AbXBZRjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030371AbXBZRjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:39:20 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:22031 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030368AbXBZRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gguirhklR6VjcfPdCgkv3JkR7aWPvK+6IoSNrnDeUtP6Rf50FDQmK/vm9Aivuj7Lft/yhi2FFRHZ5n5vxLbg9zrYWEL7a5x7/88MThc3M+9yHchze1bQHO7lmBQoWKnE0lCZ2jB6XD2mDBbnbg8OM9ph/IBb65b6bi4jh1aQC4c=
Message-ID: <e5bfff550702260939t4a071d34o6bbf3dcd4ad5b67c@mail.gmail.com>
Date: Mon, 26 Feb 2007 18:39:13 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Johannes Schindelin" <Johannes.Schindelin@gmx.de>
Subject: Re: [ANNOUNCE] qgit-1.5.5
Cc: "Martin Langhoff" <martin.langhoff@gmail.com>,
       "Git Mailing List" <git@vger.kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.63.0702261218430.22628@wbgn013.biozentrum.uni-wuerzburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5bfff550702250958n6cddc5b5lec4badf1f7fc8231@mail.gmail.com>
	 <46a038f90702251623h5944a085m514418cb5f530e7f@mail.gmail.com>
	 <e5bfff550702252219m352c03ady2d810e051bd62a37@mail.gmail.com>
	 <Pine.LNX.4.63.0702261218430.22628@wbgn013.biozentrum.uni-wuerzburg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/07, Johannes Schindelin <Johannes.Schindelin@gmx.de> wrote:
> Hi,
>
> On Mon, 26 Feb 2007, Marco Costalba wrote:
>
> > On 2/26/07, Martin Langhoff <martin.langhoff@gmail.com> wrote:
> > > On 2/26/07, Marco Costalba <mcostalba@gmail.com> wrote:
> > > > P.S: There is also a Qt4 version (works under Windows) downloadable
> > > > from git://repo.or.cz/qgit4.git  it is a little bit experimental
> > > > tough.
> > >
> > > Is the QT4 Windows port working against the MinGW port of GIT?
> > >
> >
> > Yes, Qt4Windows does not need cygwin at all and is compiled itself with
> > MinGW.
>
> I think what Martin was getting at is if you can use the MinGW port of
> _Git_, not if Qt4Windows or qgit needs cygwin.
>

Actually, I didn't test with MinGW port of Git but I would be
surprised if it doesn't work (famous last words ;-)  )


Marco
