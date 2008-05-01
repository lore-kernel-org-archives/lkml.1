Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYEANm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYEANm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbYEANmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:42:17 -0400
Received: from web50210.mail.re2.yahoo.com ([206.190.38.51]:36608 "HELO
	web50210.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757342AbYEANmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:42:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=jyIhkNZk9T3yyRi0fOmqqRXS3mQG6hFKO0EEONfS+rKsj25S2NyOxsuwNxqI/RkWyLFnbYk5Uf352Q3rbXT09NDkTdFckP9S/DmLiHpDk+Ga/Klwv1zQ/8UU0Zwmpo+I1Zk52j7nyxqcnpwvCY6bG1y94cVc24o+XwI9QjfUPLo=;
X-YMail-OSG: bJMPj_EVM1lEl4X1ykaUrhXqKAFYhIvpvDgB5esBvW5NmC8jeG8VmDrtpfC6wtY9yWZp2FPjrzWECB8NZrrYwl6.ztqYspOvbj5vF.70zwzjvYY6dap2qMBE0w--
X-Mailer: YahooMailWebService/0.7.185
Date: Thu, 1 May 2008 06:42:11 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: alex14641@yahoo.com
Subject: Re: Sharing disks amoung multiple software RAIDs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0805010849380.20043@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <232402.74959.qm@web50210.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 5/1/08, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> Subject: Re: Sharing disks amoung multiple software RAIDs
> To: "Alex Davis" <alex14641@yahoo.com>
> Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Thursday, May 1, 2008, 8:50 AM
> On Thu, 1 May 2008, Alex Davis wrote:
> 
> > Is this a bad thing? I'm guessing that it is, but
> I want independent
> > confirmation before I spoke to someone I know
> who's doing this.
> >
> > Thanks
> >
> >
> >     
> What is the use case, why would you want to do that?
> I have seen people on the list do it before, for example
> are you going to be utilizing both raids at the same time? 
Yes.

> If so, I would advise against it.
> 
> What is the reasoning?

No, I don't want to do this. I know someone who is, and I wanted to get
more input before I advised them to get more disks. The RAIDs are running
in degraded mode, so they'll need more disks anyway. Since they are (or
hopefully soon will be) buying more disks, I'll advise them to get
dedicated disks for each RAID.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
