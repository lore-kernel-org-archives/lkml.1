Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbXFDMi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbXFDMi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbXFDMiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:38:18 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59964 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbXFDMiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:38:17 -0400
Date: Mon, 4 Jun 2007 14:38:12 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Indan Zupancic <indan@nul.nu>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       dtor@insightbb.com
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
In-Reply-To: <4945.81.207.0.53.1180960534.squirrel@secure.samage.net>
Message-ID: <Pine.LNX.4.64.0706041437030.29896@twin.jikos.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <4945.81.207.0.53.1180960534.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Indan Zupancic wrote:

> > I also get some stuck keys I was not getting before. I hope my
> > userland did not go crazy...
> I get that too, and wasn't sure about it either. It happens irregularly,
> so it's hard to debug, but often enough to be annoying.

What kind of keyboards are they? I guess the x60 case is serio/ps2, what 
keyboard do you experience this with, Indan?

-- 
Jiri Kosina
