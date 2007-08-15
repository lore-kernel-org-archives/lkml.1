Return-Path: <linux-kernel-owner+w=401wt.eu-S934403AbXHORhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbXHORhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764177AbXHORhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:37:47 -0400
Received: from smtpout.mac.com ([17.250.248.184]:58825 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764198AbXHORhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:37:46 -0400
In-Reply-To: <174219.56922.qm@web52501.mail.re2.yahoo.com>
References: <174219.56922.qm@web52501.mail.re2.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F38DAAD2-D984-4704-94AC-5FB963C4373C@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 13:37:29 -0400
To: Marc Perkel <mperkel@yahoo.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 13:19:16, Marc Perkel wrote:
> One of the problems with the Unix/Linux world is that your minds  
> are locked into this one model. In order to do it right it requires  
> the mental discipline to break out of that.

The major thing that you are missing is that this "one model" has  
been very heavily tested over the years.  People understand it, know  
how to use it and write software for it, and grok its limitations.   
There's also a vast amount of *existing* code that you can't just  
"deprecate" overnight; the world just doesn't work that way.  The  
real way to get there (IE: a new model) from here (IE: the old model)  
is the way all Linux development is done with a lot of sensible easy- 
to-understand changes and refactorings.

With that said, if you actually want to sit down and start writing  
*code* for your model, go ahead.  If it turns out to be better than  
our existing model then I owe you a bottle of your favorite beverage.

Cheers,
Kyle Moffett

