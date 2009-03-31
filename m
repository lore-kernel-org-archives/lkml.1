Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbZCaPW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbZCaPW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762052AbZCaPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:21:47 -0400
Received: from smtp28.orange.fr ([80.12.242.100]:43511 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762048AbZCaPVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:21:46 -0400
X-ME-UUID: 20090331152143119.1D1597000098@mwinf2807.orange.fr
Subject: Re: Replacing VFAT as filesystem on removeable media
From: Xavier Bestel <xavier.bestel@free.fr>
To: Mark Williamson <mark.williamson@cl.cam.ac.uk>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, info@fsf.org, office@fsfeurope.org,
       info@linuxfoundation.org
In-Reply-To: <200903311602.41272.mark.williamson@cl.cam.ac.uk>
References: <200903311015.29222.Martin@Lichtvoll.de>
	 <200903311357.44075.mark.williamson@cl.cam.ac.uk>
	 <1238507227.27596.559.camel@skunk>
	 <200903311602.41272.mark.williamson@cl.cam.ac.uk>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 17:21:37 +0200
Message-Id: <1238512897.27596.579.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 16:02 +0100, Mark Williamson wrote:
> I've not heard of Linux providing an MTP responder ("server"), 
> which I find mildly surprising as it sounds like it would be useful, 
> particularly given the range of advanced filesystems Linux devices might like 
> to leverage under the hood.  It seems odd if an embedded Linux company hasn't 
> already coded this up for a device ... ?

I'm speaking out of my ass here, but seeing how Microsoft managed to
sneak some patents into something as trivial as FAT, I'm pretty sure MTP
is a hell of a minefield.

	Xav


