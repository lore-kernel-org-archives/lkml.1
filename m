Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZECM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZECM21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 08:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZECM2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 08:28:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45660 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZECM2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 08:28:18 -0400
Subject: Re: [PATCH] - Fix memory corruption in slbq
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jack Steiner <steiner@sgi.com>
Cc: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20090503122443.GA25905@sgi.com>
References: <20090501004105.GA16409@sgi.com>
	 <84144f020905030518u22c256ealb1d2511c397454e3@mail.gmail.com>
	 <20090503122443.GA25905@sgi.com>
Date: Sun, 03 May 2009 15:28:17 +0300
Message-Id: <1241353697.27683.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jack,

On Sun, 2009-05-03 at 07:24 -0500, Jack Steiner wrote:
> > I don't think this is needed now that commit 8804e6f ("SLQB:  fix dumb
> > early allocation cache") is merged:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff_plain;h=8804e6f0001668656d4cb2a329e1a6e69e695a0f
> > 
> > Or do you still see the corruption with it?
> 
> No. The above patch is an equivalent ( & better) fix. for the problem.
> You can ignore the patch that I sent.

OK, thanks for the patch anyway!

			Pekka

