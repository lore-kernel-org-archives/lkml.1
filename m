Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYEEI2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYEEI2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYEEI2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:28:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:39545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbYEEI2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:28:15 -0400
Date: Mon, 5 May 2008 10:28:14 +0200
From: Nick Piggin <npiggin@suse.de>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nopage mm.h
Message-ID: <20080505082814.GA5018@wotan.suse.de>
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com> <481D68E0.1040608@gmail.com> <dd18b0c30805040912l2d12115bi3987d8a5ed0372bf@mail.gmail.com> <20080505032843.GA14947@wotan.suse.de> <dd18b0c30805042047h79f1e025s51037d05e09e7fdb@mail.gmail.com> <20080505041954.GB17640@wotan.suse.de> <dd18b0c30805042207j4df0d78dx1291555889894776@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30805042207j4df0d78dx1291555889894776@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 05:07:00AM +0000, Justin Mattock wrote:
> On Mon, May 5, 2008 at 4:19 AM, Nick Piggin <npiggin@suse.de> wrote:
> >  OK, not sure about that one... but if it is just your personal kernel,
> >  and not for redistribution, then you are of course free to make any
> >  changes you like. Including changing EXPORT_SYMBOL_GPL. Maybe it is
> >  a reasonable temporary measure for you until you get some better
> >  drivers.
> >
> >
> 
> Cool; yes this is just for personal use only, not redistribution.
> Then in that case I'll have a look into seeing if I can get up and running again
> with 2.6.26-rc1.
> regards;

Great to see you are keen on testing the bleeding edge ;) Good luck!
