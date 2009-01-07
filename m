Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbZAGPCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbZAGPCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZAGPB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:01:57 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34674
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZAGPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:01:56 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: document ext3 requirements
Date: Wed, 7 Jan 2009 05:59:02 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: Theodore Tso <tytso@mit.edu>, "Alexander E. Patrakov" <patrakov@gmail.com>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <20090104183834.GB17558@mit.edu> <20090105114329.7973057b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090105114329.7973057b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901070559.03359.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 05:43:29 Alan Cox wrote:
> > Huh?  I've never heard an assertion that disabling the write cache (I
> > assume you mean using write-through caching as opposed to write-back
> > caching), shortens the lifespan of disk drives.  Aggressive battery
>
> Thats what I was told by a disk vendor - simply because the drive makes a
> lot more mechanical movements and writes.

It certainly sounds like less write cacheing would shorten the lifespan of 
flash devices...

Rob
