Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYCUVRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYCUVRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762539AbYCUVQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:16:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34538 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762483AbYCUVQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:16:46 -0400
Date: Fri, 21 Mar 2008 22:16:45 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's with the "pre-releases" directory?
In-Reply-To: <alpine.LFD.1.00.0803211336350.7227@localhost.localdomain>
Message-ID: <alpine.LNX.1.00.0803212216170.10642@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.1.00.0803211312500.30701@localhost.localdomain> <20080321173415.GB1434@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0803211336350.7227@localhost.localdomain>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 21 2008 13:41, Robert P. J. Day wrote:
>
> p.s.  and while i'm whining, would it be possible to clear the
> obsolete "LATEST-IS" files out of:
>
>  ftp://ftp.kernel.org/pub/linux/kernel/v2.6/testing
>
> i have a script that grabs the latest rc tarball out of that
> directory, and it got confused by seeing more than one LATEST-IS file.
> not hard to work around but, still ...

In that case, why not directly parse the directory and
do away with LATEST-IS-* ...
