Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbXCTVDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbXCTVDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXCTVDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:03:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54939 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbXCTVDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:03:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [linux-pm] 2.6.21-rc4-mm1
Date: Tue, 20 Mar 2007 22:06:37 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org
References: <20070319205623.299d0378.akpm@linux-foundation.org> <200703202158.50063.rjw@sisk.pl> <46004B02.7020407@gmail.com>
In-Reply-To: <46004B02.7020407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202206.38168.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 21:58, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> > Actually, the problem is 100% reproducible on my system too and I doubt it's
> > caused by the recent freezer patches.
> 
> I don't know what exactly do you mean by recent, but 2.6.21-rc3-mm2 works
> for me.

Thanks for the confirmation.

The patches I was talking about had already been in 2.6.21-rc3-mm2, so the
reason of this failure must be different.

Greetings,
Rafael
