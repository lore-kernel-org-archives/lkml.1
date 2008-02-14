Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbYBNHtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbYBNHtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759009AbYBNHtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:49:35 -0500
Received: from cadalboia.ferrara.linux.it ([195.110.122.101]:43573 "EHLO
	cadalboia.ferrara.linux.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758179AbYBNHtd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:49:33 -0500
From: Fabio Coatti <cova@ferrara.linux.it>
Organization: FerraraLUG
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: stuck with 2.6.23.14 on x86_64
Date: Thu, 14 Feb 2008 08:49:30 +0100
User-Agent: KMail/1.9.7
Cc: mikem13@sbcglobal.net, linux-kernel@vger.kernel.org
References: <fa.d3EyknDimPJIlJNA2Y25+wmntNM@ifi.uio.no> <04a37899-eb7b-43ae-a7ab-1928ca1a0e35@s12g2000prg.googlegroups.com> <20080213112713.e028075f.akpm@linux-foundation.org>
In-Reply-To: <20080213112713.e028075f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802140849.31155.cova@ferrara.linux.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alle mercoledì 13 febbraio 2008, Andrew Morton ha scritto:

> > > Hardware: x86_64 AMD 2216HE
> > > SCSI controller: HP Smart Array E200i Controller
> > > Compiler: gcc (GCC) 4.1.1
> > > binutils: 2.16.1
> > >
> > > On a x86 machine, Intel(R) Xeon(TM) CPU 3.20GHz
> > > with a cciss0: HP Smart Array 6i Controller,
> > > the 2.6.24.2 compiles just fine and works, so the cciss problems seems
> > > related only to E200i controller.

> > Fabio, Can you please post your boot messages in bug 9859.
>
> Let's cc him..


No problem, I'm subscribed to the list so I've already posted boot messages; 
thanks anyway :)




-- 
Fabio "Cova" Coatti    http://members.ferrara.linux.it/cova     
Ferrara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
Old SysOps never die... they simply forget their password.
