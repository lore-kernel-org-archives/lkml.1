Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbXFQAMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbXFQAMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 20:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXFQAMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 20:12:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:34985 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbXFQAME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 20:12:04 -0400
Subject: Re: [RFC] [PATCH] selective signal ptracing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roland McGrath <roland@redhat.com>, john.blackwood@ccur.com,
       linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>, bugsy@ccur.com
In-Reply-To: <20070616002615.7c727d75@the-village.bc.nu>
References: <4672A2ED.6030401@ccur.com>
	 <20070615194229.AF0984D059F@magilla.localdomain>
	 <20070616002615.7c727d75@the-village.bc.nu>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 10:11:02 +1000
Message-Id: <1182039062.26853.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-16 at 00:26 +0100, Alan Cox wrote:
> On Fri, 15 Jun 2007 12:42:29 -0700 (PDT)
> Roland McGrath <roland@redhat.com> wrote:
> 
> > I am not in favor of any enhancements to the ptrace interface.
> > It is a terrible interface and just needs to die.
> 
> That might make sense if utrace ever looked like it would solve the
> questions about platforms like ARM

What are the issues with arch like ARM ? Also, is there a mail thread or
paper somewhere describing utrace, its interfaces and what's needed to
hook it up on a platform ?

/me mostly missed that train

Thanks !

Cheers,
Ben.



