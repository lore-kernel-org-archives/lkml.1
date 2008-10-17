Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbYJQBZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbYJQBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJQBZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:25:47 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45855
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYJQBZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:25:47 -0400
From: Rob Landley <rob@landley.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Thu, 16 Oct 2008 20:26:57 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081016002509.GA25868@kroah.com>
In-Reply-To: <20081016002509.GA25868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810162026.57857.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2008 19:25:09 Greg KH wrote:
> Hi,
>
> You brought this topic up a few months ago, and passed it off as
> something we would discuss at the kernel summit.  But that never
> happened, so I figured I'd bring it up again here.
>
> So, as someone who constantly is dealing with kernel version numbers all
> the time with the -stable trees, our current numbering scheme is a pain
> a times.  How about this proposal instead?

I don't understand, what exactly is a pain about it?  (I can't tell why a new 
one is better if you don't say what you're objecting to about the old one...)

> Benefits of this is it more accuratly represents to people just how old
> the kernel they are currently running is (2.6.9 would be have been
> 2004.9.0 on this naming scheme.)

Benefits is plural, but I seem to have missed the other ones.  Or is that the 
only issue, wanting to put a more prominent "best if used by" date in the 
name ala Windows 95?

Rob
