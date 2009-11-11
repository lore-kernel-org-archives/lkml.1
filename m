Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZKKGyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZKKGyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZKKGys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:54:48 -0500
Received: from serv04.lahn.de ([213.239.197.57]:53682 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZKKGys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:54:48 -0500
X-Greylist: delayed 1753 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2009 01:54:47 EST
Date: Wed, 11 Nov 2009 07:25:37 +0100
From: Philipp Matthias Hahn <pmhahn@pmhahn.de>
To: Mariusz Smykula <mariuszs@gmail.com>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.29+ broke Cisco VPN Client
Message-ID: <20091111062537.GA13282@pmhahn.de>
Mail-Followup-To: Mariusz Smykula <mariuszs@gmail.com>,
	Fabio Comolli <fabio.comolli@gmail.com>,
	linux-kernel@vger.kernel.org
References: <3642a3130911090908i55d6e1f2y6d9a5106d9febfc6@mail.gmail.com>
 <20091109175728.4eec67b9@lxorguk.ukuu.org.uk>
 <3642a3130911092236p11ef0502se12788800c8d2084@mail.gmail.com>
 <3642a3130911092304x5c8fe8ddme1df39e6981cfe0a@mail.gmail.com>
 <b637ec0b0911092348x29453bco7f7ca94f3772601@mail.gmail.com>
 <3642a3130911100149t7452a6f3k188e0fe972783521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3642a3130911100149t7452a6f3k188e0fe972783521@mail.gmail.com>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 10, 2009 at 10:49:48AM +0100, Mariusz Smykula wrote:
> On Tue, Nov 10, 2009 at 8:48 AM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> > Please have a look at:
> >
> > http://forum.tuxx-home.at/viewtopic.php?f=15&t=790#p5227
> >
> > There is a patch there that can be used to make CiscoVPN work with the
> > latest stable kernels. For me it worked fine (over a wifi connection)
> > until I lost interest as now I'm able to use vpnc, thanks to the
> > people on the vpnc support forum.
> 
> I have no problem to compile and connect using CiscoVPN + 2.6.31, but
> this is unstable solution. After some time (seconds or minutes) whole
> computer is freezing dead.
> 
> vpnc is no option, because he lacks supports of certs auth.

You might want to give http://www.shrew.net/software a try. I'd be
interested if this works for you.

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
