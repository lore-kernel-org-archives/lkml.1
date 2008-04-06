Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbYDFLIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbYDFLIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 07:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYDFLH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 07:07:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39316 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYDFLH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 07:07:57 -0400
Date: Sun, 6 Apr 2008 13:08:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, apw@shadowen.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080406110823.GA18058@uranus.ravnborg.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080406100826.GD30987@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080406100826.GD30987@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >     This also relaxes the tab doctrine, because spaces DO make sense --
> >     especially when you view the code with a tab setting of not-8.
> >...
> 
> In the kernel all tabs are 8 spaces wide.
> 
> When you view the code with a different setting that's your fault.
And for other kernel developers tabs are for indention, spaces for alignment.

Forget it - the world will not unify about this.

	Sam
