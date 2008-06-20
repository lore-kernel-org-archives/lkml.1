Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYFTBrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYFTBrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 21:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYFTBrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 21:47:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40467 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYFTBrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 21:47:03 -0400
Date: Fri, 20 Jun 2008 02:47:00 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jan Beulich <jbeulich@novell.com>
cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: agp: two-stage page destruction issue
In-Reply-To: <485A4715.76E4.0078.0@novell.com>
Message-ID: <alpine.DEB.0.82.0806200246300.12492@skynet.skynet.ie>
References: <4858E330.76E4.0078.0@novell.com>
 <21d7e9970806181657l79fa4e43oc42f23a18a33c4ee@mail.gmail.com>
 <485A4715.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> So if you're considering it even for 2.6.26, will you push it to Linus? That's
> how I understand the process would generally work, or should I push it
> in this case (in which case it might be good to know whether your above
> statement should be translated into an Acked-by or Signed-off-by)?

Its already pushed :)
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=da503fa60b84d5945deb3ab74efdd0bec61df4a1

Dave.
