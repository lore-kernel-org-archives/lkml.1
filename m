Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYIIUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYIIUqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYIIUqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:46:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbYIIUqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:46:08 -0400
Date: Tue, 9 Sep 2008 13:45:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Sanders <linux@sandersweb.net>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <200809091637.32650.linux@sandersweb.net>
Message-ID: <alpine.LFD.1.10.0809091345100.3117@nehalem.linux-foundation.org>
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org> <200809091518.16311.linux@sandersweb.net> <alpine.LFD.1.10.0809091255420.3117@nehalem.linux-foundation.org> <200809091637.32650.linux@sandersweb.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Sep 2008, David Sanders wrote:

> On Tuesday 09 September 2008 15:56, Linus Torvalds wrote:
> > On Tue, 9 Sep 2008, David Sanders wrote:
> > > I haven't seen this come across the wire in Linus's 2.6.27 tree.  We're
> > > still going to do this right?
> >
> > Latest version is out there now (leaving the gas-error-proofing for
> > later),
> 
> The Kconfig.cpu change wasn't in my git pull.

It's commit 14469a8dd23677921db5e7354a602c98d9c6300f.

Maybe it hadn't finished mirroring out?

		Linus
