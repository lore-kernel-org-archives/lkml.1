Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0CEQhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:37:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51693 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752194Ab0CEQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:37:16 -0500
Date: Fri, 5 Mar 2010 16:38:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luca Barbieri <luca.barbieri@gmail.com>,
       Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
Subject: Re: [git pull] drm request 3
Message-ID: <20100305163817.143ee6f5@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003050814410.3788@localhost.localdomain>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	<20100305.063718.211238119.davem@davemloft.net>
	<20100305151754.GB2505@tempa>
	<20100305.072612.186421758.davem@davemloft.net>
	<20100305154009.GC2505@tempa>
	<ff13bc9a1003050756rca44e03uffbfa3090f96e0ac@mail.gmail.com>
	<20100305161311.656711e0@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003050814410.3788@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The thing I objected to, in the VERY BEGINNING in this thread, i the fact 
> that the thing was done in such a way that it's basically impossible to 
> support the old/new ABI at all! 

What did you expect them to do. They said when you first forced a merge
that they would do this. They have no contract that I am aware of to
deliver you compatibility, in fact quite the reverse they said they
wouldn't be.

Then you attribute to malice what was done as a cleanup by people
who've pointedly never to commited to a constant API yet

 "That commit seems to _on_purpose_ try to avoid at all cost being 
  compatible."

Great way to make friends.

Alan
