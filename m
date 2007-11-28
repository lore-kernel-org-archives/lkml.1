Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbXK1Kko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbXK1Kko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbXK1Kke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:40:34 -0500
Received: from web36702.mail.mud.yahoo.com ([209.191.85.36]:43883 "HELO
	web36702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755946AbXK1Kkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:40:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=u5bQVkkafQ3Y1i06prGvtN3nDndUjraeQ0m4jv5mk/Fnq99zaFRFr2nPZognWhYvtONbGH9g4IQONcnJ0cnRvwSDCATw7oQGPzt7jtBsTdBVfbbcKKbly5gh1e/yj2dGlEvrC8wPR0M7eXd6+TDWtEIMGJBPivlgbLQV+CAh3gQ=;
X-YMail-OSG: XhUIpVcVM1kYun3TzWIDEKS2bav2Lrr20jgLI.PIV6HzOitNumEmeeTIjzlNBRdYjlcqeiqixIETRwvfPzhaRIj2XIvKZIjHSZP9sI5f.6scMCwbTnc-
Date: Wed, 28 Nov 2007 02:40:32 -0800 (PST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: Re: Linux 2.6 kernel module compilation without using KBUILD
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.9999.0711280453330.3612@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <815347.48604.qm@web36702.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> On Wed, 28 Nov 2007, murtuja bharmal wrote:
> 
> > Hello Sam,
> >
> > My intention is to just understand whole process
> of making kernel
> > module. Actually I am working on one project in
> which I have to port
> > lots of 2.4 kernel module in 2.6 kernel. So I
> thought lets first try
> > to understand, what is going behind KBUILD. I also
> gone through
> > linux/Documentation/kbuild/ but didn't get very
> much information.
> > Even after running it on Verbose Mode, I am not
> very much clear.
> >
> > Thanks
> > Murtuja Bharmal
> 
> you'd probably be better off asking this on the
> kernel newbies list
> rather than the main kernel list.  and, as an intro
> to porting 2.4 to
> 2.6 modules, you might want to start here:
> 
> http://lwn.net/Articles/driver-porting/
> 
> and, as others have suggested, you're probably
> better off just
> figuring out the 2.6 kbuild structure.  trying to do
> this manually
> without kbuild is just making this way more
> difficult than it has to
> be.
> 
> rday
> 
>
========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel
> Pedantry
> Waterloo, Ontario, CANADA
> 
> http://crashcourse.ca
>
========================================================================
> 
Hello Robert,

I think I am not very much clear. Let me try to
clarify more.
My intention is not build or port kernel driver
without using KBUILD.
I know about driver porting and Writing makefile using
KBUILD.
I don't have any issue about that.
       
I just want understand the whole process for clearity
thats it.
unfortunately I didn't get any answer from linux-doc
and linux-admin about this issue.
Let me try to understand KBUILD internal architecture
more by self.

Any Way.
Thanks for your view.
Murtuja Bharmal



      ____________________________________________________________________________________
Be a better pen pal. 
Text or chat with friends inside Yahoo! Mail. See how.  http://overview.mail.yahoo.com/
