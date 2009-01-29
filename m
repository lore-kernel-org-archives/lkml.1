Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbZA2QXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbZA2QXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZA2QXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:23:07 -0500
Received: from twin.jikos.cz ([213.151.79.26]:48456 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZA2QXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:23:06 -0500
Date: Thu, 29 Jan 2009 17:22:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pazzo Da Legare <pazzodalegare@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NEWBIE: how to change serial device<->port association
In-Reply-To: <20090129160602.235840c2@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LRH.1.10.0901291722360.13097@twin.jikos.cz>
References: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com> <20090129134537.12121834@lxorguk.ukuu.org.uk> <1a26b4920901290616r40c1edd0tec62d0e6bf24dc9@mail.gmail.com> <20090129160602.235840c2@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Alan Cox wrote:

> > The hws have a different combination of kind serials and I would like
> > to present the same ttyS* to applications. I need to have different
> By having multiple different kernels for the different systems ? That
> sounds like a really really complicated way to go about the problem when
> you could just add a config file to your application.

Another possibility is udev rule.

-- 
Jiri Kosina
SUSE Labs

