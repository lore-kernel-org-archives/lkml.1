Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZI0HDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZI0HDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 03:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZI0HDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 03:03:53 -0400
Received: from ozlabs.org ([203.10.76.45]:39323 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbZI0HDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 03:03:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] module: Fix up CONFIG_KALLSYMS=n build.
Date: Sun, 27 Sep 2009 16:33:53 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: "Am?rico Wang" <xiyou.wangcong@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20090925034557.GA12810@linux-sh.org> <200909251724.21416.rusty@rustcorp.com.au> <20090925081403.GA2736@merkur.ravnborg.org>
In-Reply-To: <20090925081403.GA2736@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909271633.54811.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 05:44:03 pm Sam Ravnborg wrote:
> On Fri, Sep 25, 2009 at 05:24:20PM +0930, Rusty Russell wrote:
> > Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Hmm, I expected you to take this patch and forward to Linus?
> In which case I had expected to see a "S-o-b".

Andrew already took it, and I'd already pushed my modules patches.  Seemed
like the fastest way to get this in?

Cheers,
Rusty.
