Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbXF0GSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbXF0GSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbXF0GSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:18:05 -0400
Received: from web52510.mail.re2.yahoo.com ([206.190.48.193]:37378 "HELO
	web52510.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757314AbXF0GSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:18:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5Cj0unG+aUZZxcqngHs2TRLU7sLhKKxM0+xYlHxknSJguLv4jZ1gnPBSvEX/K0alAFIliS23laK+t6K+CHncHrZWVCI5SBGsgkuwjFBQgoRQjeP9PlDGxy97QkiOkAtwB1ZmPqGHmJkYY2PbmAuZiBqGjcDS9rjGSCPn1yxKW3I=;
X-YMail-OSG: jXuyCBgVM1kblEh9i7gyppahBNpJgdsXEvwtk8yv_q75NyMQtGBp0dUaCeVDResjUA--
Date: Tue, 26 Jun 2007 23:18:01 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: NVidia Driver Support - 1680x1050 mode
To: Michael Lothian <mike@fireburn.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fc94aae90706262226p417ed77ex97dd20f9bec46e25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <964847.10954.qm@web52510.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If I were to try a different brand of video card to
get 1680x1050 where the main criteria was "just
works", what brand should I get?


--- Michael Lothian <mike@fireburn.co.uk> wrote:

> OK where to start?
> 
> Firstly this is really the wrong list your writing
> to. Chances are
> you'll be wanting to ask your question at
>
http://www.nvnews.net/vbulletin/forumdisplay.php?s=&forumid=14
> if your
> using the Nvidia Blob otherwise if your using the 2D
> only NV driver
> then you should really aim your question at the Xorg
> guys and gals
> 
> Secondly how exactly did you tell it differently?
> 
> Chances are your /etc/conf.d/xorg.conf is wrong if
> you were using the
> latest X server with the latest binary blob (nvidia
> driver) chances
> are it would detect the highest resolution and set
> it for you. The
> program nvidia-xconfig should fix the file for you.
> 
> Oh and thirdly do you really think it just works on
> windows is a good
> incentive to get people to help you? Yes it should
> work out the box
> but unfortunately the world of Linux 3D drivers is
> mostly dominated
> with company's that prefers keeping their drivers in
> a black box and
> hopefully in the not too distant future the neuveau
> project might
> remedy this.
> 
> Any way I hope this e-mail both helps with your
> problems and adds to
> your understanding of how things work. The kernel
> mailing list is for
> kernel issues (which include rivafb and nvidiafb but
> not nv and nvidia
> 3d issues) so if you ever plug in a hard drive and
> it's not working at
> full speed or something along those lines that's
> when you should call.
> 
> Cheers
> 
> Mike
> 
> On 27/06/07, Marc Perkel <mperkel@yahoo.com> wrote:
> > Trying to get my Asus M2NPV-VM motherboard and my
> > Samsung SyncMaster 215tw Digital to work in
> 1680x1050
> > mode but 1280x1024 is the most I can get. Chip Set
> is
> > GeForce 6150.
> >
> > Looking in Xorg.0.log it ssems to think that the
> panel
> > size is 1280x1024 in spite of my setting telling
> it
> > differently.
> >
> > Sorry if this is off topic but I thought that the
> > smart people would be here. In Windows I just plug
> it
> > in and it works. So I figure Linux should work
> too. :)
> 



       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433
