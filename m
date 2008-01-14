Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYANUAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYANUAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYANUAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:00:45 -0500
Received: from mercury.sdinet.de ([193.103.161.30]:40348 "EHLO
	mercury.sdinet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbYANUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:00:44 -0500
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2008 15:00:44 EST
Date: Mon, 14 Jan 2008 20:50:23 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
In-Reply-To: <alpine.LFD.1.00.0801141436590.22800@localhost.localdomain>
Message-ID: <alpine.DEB.1.00.0801142049270.7057@mercury.sdinet.de>
References: <200801141434.00934.gene.heskett@gmail.com> <alpine.LFD.1.00.0801141436590.22800@localhost.localdomain>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008, Robert P. J. Day wrote:

> On Mon, 14 Jan 2008, Gene Heskett wrote:
> 
> > Greetings;
> >
> > Do we have a utility that can force the kernel to re-read, and
> > re-initialize itself to a given drives partition tables without
> > having to reboot if one is working with a drive that is not part of
> > the required kernel directory tree?
> 
> i would try "partprobe".

or "sfdisk -R /dev/sdX"

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around
it. (John Gilmore on http://www.cygnus.com/~gnu/)
