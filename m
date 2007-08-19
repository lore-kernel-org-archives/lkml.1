Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbXHSEHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbXHSEHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 00:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXHSEHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 00:07:09 -0400
Received: from web52501.mail.re2.yahoo.com ([206.190.48.184]:27934 "HELO
	web52501.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750757AbXHSEHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 00:07:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=AUpTjuUR9T+HHetR4sB/QP41WzOo0Q1rK23tu4lLEby2e4ySoQfq0H8QcFORTisEJGeEdRWXohy9PFRmR7Z+Usp4The2z+xkvlmUa8CesqLiLdB+zv94vnvSPIhLuyNSIkC72GjX43wzBQPZqrgW9uZCPIsvsIRsLtGd1Q7s6p0=;
X-YMail-OSG: AoHnP4wVM1nBGM3c45nsG64Zvr.Xvm6jsrSfEsSO7BaicNjN_7MXMjGjF0.OztDwe68BfoPbmQprB3JkPvBSTUmksALuo9Wzh8v1mcrzTwjWvEWIBzpRL5IFezLoFZM6S_6FMLOtWGweqUc-
Date: Sat, 18 Aug 2007 21:07:05 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Phillip Susi <psusi@cfl.rr.com>,
       Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20070818181959.GP21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <900404.40407.qm@web52501.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No Al, there isn't any shortage of arrogance here.

Let me try to repeat what I'm talking about as simply
as I can.

First - I'm describing a kind of functionality and
suggesting Linux should have it. I know a lot of it
can be done because much of what I'm suggesting is
already working in Windows and Netware.

I'm not the one who's going to code it. I'm just
saying that it would be nice if Linux had the
functionality of other operating systems - and - take
it to the next level - match it and do even better.

As to thinking outside the box, what I'm proposing is
outside the box relative to Linux. It's not as
original as compared to Windows or Netware which is
even better.

The idea is that Linux is lacking features that other
OSs have. What I'm suggesting is that Linux not only
match it but to create an even more powerful rights
layer that is more powerful than the rest and I'm
outlining a concept in the hopes that people would get
excited about the concept and want to build on the
idea.

I'm just telling you what I'd like to see. I'm not
going to code it. So I'm only going to talk about what
is possible. How it's done will be up to any
programmers who might be inspired by the idea. If no
one is inspired the Linux will continue to be in last
place when it comes to file system features relating
to fine grain permissions.

In Linux, for example, users are allowed to delete
files that they are prohibited from reading or
writing. In Netware if a user can't read or write to
the file they won't even be able to see that the file
exists, let alone delete it.

In Netware I can move a directory tree into another
tree and the objects that have rights in the other
tree will have rights to all the new files without
having to run utilities on the command line to
recursively change the permission afterwards. 

The point - Linux isn't going to move forward and
catch up unless there is a fundamental change in the
thinking  behind Linux permissions. There is a
cultural lack of innovation here. I discussed this
with Andrew Morton and he made some suggestions but
there's real hostility towards new concepts here.
Something I don't understand. At some point Linux
needs to grow beyond just being an evolved Unix clone
and that's not going to happen if you don't think
differently.

I still believe that the VI editor causes brain
damage. :)




Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Park yourself in front of a world of choices in alternative vehicles. Visit the Yahoo! Auto Green Center.
http://autos.yahoo.com/green_center/ 
