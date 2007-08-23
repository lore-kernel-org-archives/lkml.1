Return-Path: <linux-kernel-owner+w=401wt.eu-S1765018AbXHWP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765018AbXHWP7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762254AbXHWP7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:59:33 -0400
Received: from web32614.mail.mud.yahoo.com ([68.142.207.241]:23454 "HELO
	web32614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755727AbXHWP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:59:32 -0400
X-YMail-OSG: BuL9ue8VM1nbDTqIrRjC2lEc1fokHGOAGncRJIrERj7mpWVuhtVjNh0944o3lfXmR3jQO5lBUgjYJSCpdY5ECPlbTQ--
X-RocketYMMF: knobi.rm
Date: Thu, 23 Aug 2007 08:59:30 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: RE: [PATCH 00/23] per device dirty throttling -v9
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1187268920.6114.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <137637.20782.qm@web32614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2007-08-16 at 05:49 -0700, Martin Knoblauch wrote:
> 
> > Peter,
> > 
> >  any chance to get a rollup against 2.6.22-stable?
> > 
> >  The 2.6.23 series may not be usable for me due to the
> > nosharedcache changes for NFS (the new default will massively
> > disturb the user-space automounter).
> 
> I'll see what I can do, bit busy with other stuff atm, hopefully
> after
> the weekend.
> 
Hi Peter,

 any progress on a version against 2.6.22.5? I have seen the very
positive report from Jeffrey W. Baker and would really love to test
your patch. But as I said, anything newer than 2.6.22.x might not be an
option due to the NFS changes.

Kind regards
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
