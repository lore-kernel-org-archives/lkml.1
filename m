Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbXEaEwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbXEaEwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbXEaEv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:51:59 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:23414 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693AbXEaEv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nuQJZsT3QoacjZ30eI+0CzZpEQrT3XXDbQebW6y15P/rZH3+qaGLGeawr/G+l998rmxXedmC6iEezn9M8lTIaZKrY9frmmMk3CYQXnqbaYVjEluZaEUCBlXzQK/L5DXsnGVShfWzG3JNmhXUJKuP9d0jnCYL7ndDpCcGOkfUk8Q=
Subject: Re: [3/4] 2.6.22-rc3: known regressions
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Tero Roponen <teanropo@jyu.fi>
In-Reply-To: <alpine.LFD.0.98.0705301922560.26602@woody.linux-foundation.org>
References: <465C188F.9000900@googlemail.com>
	 <465C222A.8060003@googlemail.com>
	 <alpine.LFD.0.98.0705301922560.26602@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 31 May 2007 12:51:49 +0800
Message-Id: <1180587109.4570.25.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 19:33 -0700, Linus Torvalds wrote:
> 
> On Tue, 29 May 2007, Michal Piotrowski wrote:
> > 

> > TTY
> > 
> > Subject    : tty-related oops in latest kernel(s)
> > References : http://lkml.org/lkml/2007/5/27/104
> > Submitter  : Tero Roponen <teanropo@jyu.fi>
> > Status     : problem is being debugged
> 
> People seem to have debugged this to neofb palette handling, but I haven't 
> seen a patch. Antonino?
> 

Already posted one for testing. I'm waiting for Tero to confirm.

Tony


