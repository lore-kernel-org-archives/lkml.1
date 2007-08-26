Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbXHZGsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbXHZGsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 02:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXHZGsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 02:48:22 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43821
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736AbXHZGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 02:48:21 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] include linux/pagemap.h in asm-generic/tlb.h
Date: Sun, 26 Aug 2007 01:48:18 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
References: <20070824184616.GA9442@c2.user-mode-linux.org> <200708241551.41628.rob@landley.net> <20070824224651.GA11512@c2.user-mode-linux.org>
In-Reply-To: <20070824224651.GA11512@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708260148.18261.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 5:46:51 pm Jeff Dike wrote:
> On Fri, Aug 24, 2007 at 03:51:41PM -0500, Rob Landley wrote:
> > It may be non-urgent to you, but it still broke my build. :)
> >
> > Acked-by: Rob Landley <rob@landley.net>
>
> Heh, it doesn't seem like -stable material to me, but if there aren't
> any screams while it sits in -mm, maybe it's 2.6.23 material.

I believe 2.6.22 built for me without the patch.  It was 2.6.23-rc3 that 
needed it.

(I have a bad head cold right now so I'm not going back to confirm this 
belief.  I am, instead, making tea.)

> 				Jeff

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
