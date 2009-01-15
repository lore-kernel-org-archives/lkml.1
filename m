Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbZAOKGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbZAOKGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbZAOKGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:06:24 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:35594 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZAOKGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QtDrjHXk8gkFQ2kJMhSLfhB9o2vOD1Q86l1DHg1tNSku21RjdWClIVMvPRY97zTkwu
         Eo+oaF2l4R+aO97xg3gN0X9sNEnjpK5NGH+bA/vx60foi6jCGFasHwPyKOzR4q3as/bQ
         zPXNvZa68jzb9Oyj5xkMzSGZTXD29gFh5u8FE=
Date: Thu, 15 Jan 2009 10:06:16 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: Badalian Vyacheslav <slavon@bigtelecom.ru>, Chris Caputo <ccaputo@alt.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090115100616.GC5461@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local> <496F04AB.2080705@bigtelecom.ru> <20090115095454.GA5461@ff.dom.local> <200901151157.13340.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901151157.13340.denys@visp.net.lb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:57:13AM +0200, Denys Fedoryschenko wrote:
> I didn't notice a bug, just because all that time i was using it without 
> hrtimers (because of nmi_watchdog).
> 

Yes, it's strange: I think Slavon reported it happened without hrtimers
too.

Jarek P.
