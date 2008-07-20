Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYGTX4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYGTX4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYGTXz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:55:56 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:22876 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753797AbYGTXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:55:55 -0400
Date: Mon, 21 Jul 2008 08:55:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] input: Clean up maple keyboard driver
Message-ID: <20080720235530.GA19854@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-input <linux-input@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1213559019.22707.12.camel@localhost.localdomain> <20080718224323.GA19263@linux-sh.org> <1216469879.8959.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216469879.8959.0.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 01:17:59PM +0100, Adrian McMenamin wrote:
> On Sat, 2008-07-19 at 07:43 +0900, Paul Mundt wrote:
> > On Sun, Jun 15, 2008 at 08:43:39PM +0100, Adrian McMenamin wrote:
> > > Have a single probe function instead of a probe and a connect function.
> > > Also tidy a comment.
> > > 1 files changed, 33 insertions(+), 48 deletions(-)
> > > 
> > > 
> > > Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > 
> > Ok, so I was going to take this through my tree, but it doesn't apply any
> > more. Please send an updated version that can be merged.
> 
> What is the problem? Is it just a badly formed patch or has something
> changed elsewhere?
> 
> I'll have a look but as I have no issues I'm not sure what is wrong.
> 
The problem is it doesnt apply, and the code it is against has also
changed. If you have no issues, you obviously havent tried to apply it.
