Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYAHP4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYAHP4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYAHP4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:56:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:49356 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYAHP4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=SbtCx+5gF+HwpyUsUZVOlFvSkTYfhbAU78cnp7XVydOrv6+VY0CjL1tTWKsSk65gxqzpYs4epAIPUa04iuiq1E30kHpZMPuQJ6eQJRgi92VpzgUFfHjJsUVT8lHmAxPfyjGGZvKY30qkewtB/QOmSR/0jxWKdd/K9oJJNQjS0cI=
Date: Tue, 8 Jan 2008 16:55:30 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080108165530.19b2d03a@Varda>
In-Reply-To: <200801081630.31110.mb@bu3sch.de>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<200801071830.51895.mb@bu3sch.de>
	<20080107212344.1372cc47@Varda>
	<200801081630.31110.mb@bu3sch.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 8 Jan 2008 16:30:30 +0100
Michael Buesch <mb@bu3sch.de> escribió:

> On Monday 07 January 2008 21:23:44 Alejandro Riveira Fernández wrote:
>
> >  
> >  How can I check? The source code I build does indeed have the line
> >  you quoted on net/mac80211/rx.c:1486 Is that what you are asking for?
> >  
> >  WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
> 
> Yes fine.
> Patches are on their way. Ignore the warning for now. It is harmless.
> 

  Thank you very much for your time. Keep on the good work :)


