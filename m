Return-Path: <linux-kernel-owner+w=401wt.eu-S965417AbXBOJ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417AbXBOJ5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 04:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965424AbXBOJ5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 04:57:08 -0500
Received: from zakalwe.fi ([80.83.5.154]:37454 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417AbXBOJ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 04:57:07 -0500
Date: Thu, 15 Feb 2007 11:56:27 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Mauro Carvalho Chehab <mchehab@linuxtv.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 000/196] V4L/DVB updates
Message-ID: <20070215095627.GD11613@zakalwe.fi>
References: <1171519195.6703.25.camel@areia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1171519195.6703.25.camel@areia>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 03:59:55AM -0200, Mauro Carvalho Chehab wrote:
> Basically, this series adds support for a bunch of newer cards and newer
> drivers, do some relevant cleanups on cx88 (improving source code 
> readability and reducing binary code size), adds FM radio support on
> pvrusb2 and do several other fixes and improvements.
> 
> A more detailed log:
> 
> [removed 100+ lines of stuff]
> > 
> PS.: Due to the size of this series, I'm not mailbombing them into LKML.
> 
> V4L/DVB development is hosted at http://linuxtv.org

Why weren't these submitted in smaller batches? Why were all these 
patches held back before releasing any?

Heikki Orsila

