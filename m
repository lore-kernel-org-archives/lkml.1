Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZASPWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZASPWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 10:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZASPV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 10:21:56 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:36421 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZASPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 10:21:55 -0500
Date: Mon, 19 Jan 2009 10:21:04 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Daolong Wang <ahlongxp@gmail.com>
Cc: Rob Landley <rob@landley.net>, user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Am?rico Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [Patch] uml: fix a link error
Message-ID: <20090119152104.GC6432@c2.user-mode-linux.org>
References: <20090115194033.GA10926@hack.private> <20090116124158.4364e269.akpm@linux-foundation.org> <200901170328.15178.rob@landley.net> <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 02:23:46PM +0800, Daolong Wang wrote:
> I can confirm this link error. 

In what environment?  I see no problems here.

> And this patch works for me.

Maybe it fixes the link failure.  But I really doubt that sigprocmask works.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
