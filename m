Return-Path: <linux-kernel-owner+w=401wt.eu-S934787AbXHOR72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934787AbXHOR72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760574AbXHOR7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:59:18 -0400
Received: from web52512.mail.re2.yahoo.com ([206.190.48.195]:20861 "HELO
	web52512.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760516AbXHOR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:59:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Vx9V+KlGlXWFnsrK3ZoDizjNR7z7DcZYQ13XUdj4gliYO73hLlPublSxuLFy6aAA1Ucuo3HPBVrDkIjfDxjeHtawI4Ov/hJtYmzjcdqGCALJQhZbK1xwNYHqi0etTXd+vXSwFrdS9RicLZl6UHZWVnyXS+0d20Wgg3Ghkr4qlT0=;
X-YMail-OSG: RRIZqfYVM1kehqR6Vh0idJU1UEVYo9CMqKpqv8qZLmWHanus5rP8uXHueAAsMBfWp7I2mY4iMwuIuB9Xbuu7U7GJDlBRHlsjN7EcILTjDpZ6rjGovr48WhSlewAc7NSAqTA742SjsmAVlQ--
Date: Wed, 15 Aug 2007 10:59:12 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <F38DAAD2-D984-4704-94AC-5FB963C4373C@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <631385.29200.qm@web52512.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 15, 2007, at 13:19:16, Marc Perkel wrote:
> > One of the problems with the Unix/Linux world is
> that your minds  
> > are locked into this one model. In order to do it
> right it requires  
> > the mental discipline to break out of that.
> 
> The major thing that you are missing is that this
> "one model" has  
> been very heavily tested over the years.  People
> understand it, know  
> how to use it and write software for it, and grok
> its limitations.   
> There's also a vast amount of *existing* code that
> you can't just  
> "deprecate" overnight; the world just doesn't work
> that way.  The  
> real way to get there (IE: a new model) from here
> (IE: the old model)  
> is the way all Linux development is done with a lot
> of sensible easy- 
> to-understand changes and refactorings.
> 
> With that said, if you actually want to sit down and
> start writing  
> *code* for your model, go ahead.  If it turns out to
> be better than  
> our existing model then I owe you a bottle of your
> favorite beverage.
> 
> Cheers,
> Kyle Moffett
> 


When one thinks outside the box one has to think about
evolving beyond what you are used to. When I moved
beyond DOS I have to give up the idea of 8.3 file
names. The idea here is to come up with a model that
can emulate the existing system for backwards
compatibility.

The concept behind my model is to create a new layer
where you can do ANYTHING with file names and
permissions and create models that emulate Linux, DOS,
Windows, Mac, or anything else you can dream of. Then
you can create a Linux/Windows/Mac template to emulate
what you are used to.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Boardwalk for $500? In 2007? Ha! Play Monopoly Here and Now (it's updated for today's economy) at Yahoo! Games.
http://get.games.yahoo.com/proddesc?gamekey=monopolyherenow  
