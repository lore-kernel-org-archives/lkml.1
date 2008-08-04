Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbYHDTaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbYHDTaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbYHDT37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:29:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46753 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbYHDT36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:29:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nico Schottelius 
	<nico-linux-kernel-bugreport20080731@schottelius.org>
Subject: Re: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Date: Mon, 4 Aug 2008 21:32:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <20080731210507.GA6094@denkbrett.schottelius.org> <20080804090654.GA4747@denkbrett.schottelius.org> <20080804161443.GA4905@denkbrett.schottelius.org>
In-Reply-To: <20080804161443.GA4905@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808042132.41020.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of August 2008, Nico Schottelius wrote:
> Hello again!
> 
> I retested it with linux-next + updates from its branches
> (=2.6.27-rc1-next-20080804-denkbrett-03792-g1d2be1a)
> 
> with and without the patch.
> 
> The result is still the same as below.
> 
> No xorg is running, btw.
> 
> Sincerly,
> 
> Nico
> 
> ps: I am using this tree:
> 
>    http://unix.schottelius.org/cgi-bin/gitweb.cgi?p=foreign/linux-2.6;a=summary
> 
>    Which is linux-next-20080804 + merges from the listed branches.

Well, fine, but this is not exactly helpful.

Can you test the current Linus' tree with the patch from bug #11178, please?

Thanks,
Rafael
