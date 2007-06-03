Return-Path: <linux-kernel-owner+w=401wt.eu-S1763772AbXFCFyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763772AbXFCFyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 01:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXFCFyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 01:54:32 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39769
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbXFCFyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 01:54:31 -0400
From: Rob Landley <rob@landley.net>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: What is the kernel documentation mailing list ?
Date: Sun, 3 Jun 2007 01:54:18 -0400
User-Agent: KMail/1.9.1
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Piyush K <piyush.ker@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <a4b287450706010414j5435ed39hc89a93911a5fe24c@mail.gmail.com> <9a8748490706010426r1c6e5b38m7ab12086695fe3f6@mail.gmail.com> <20070601234839.GF3390@sequoia.sous-sol.org>
In-Reply-To: <20070601234839.GF3390@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706030154.19261.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2007 7:48 pm, Chris Wright wrote:
> * Jesper Juhl (jesper.juhl@gmail.com) wrote:
> > On 01/06/07, Piyush K <piyush.ker@gmail.com> wrote:
> > >Hi,
> > >What is the kernel documentation mailing list where I can discuss
> > >kernel documentation changes ?
> > >Please cc to my email address too.
> > >Thanks,
> > >PYK
> > 
> > As far as I know, there is no dedicated list for documentation issues.
> > There was a linux-doc@vger.kernel.org list at one point but I think it
> > died - not 100% sure though.
> 
> There is some recent attempt to bring it back to life.

Er, yes.  Me. :)

The Linux Foundation is paying me to focus on documentation for a while.  
(Woot!)  I just got http://kernel.org/doc up a few days ago (it needs lots 
more work), and I'm pondering setting up a git repository if my queue of 
patches to move files around in Documentation gets too long.  I'm also slowly 
reading through the "make htmldocs" output, beating on doclifter, writing new 
documentation...

What do you need? :)

Rob
