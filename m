Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbZCaNeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbZCaNeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760436AbZCaNd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:33:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43533 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759764AbZCaNd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:33:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Linux 2.6.29
Date: Tue, 31 Mar 2009 15:33:15 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rjw; KDE/4.2.1; x86_64; ; )
Cc: "Hans-Peter Jansen" <hpj@urpla.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <200903310000.11522.hpj@urpla.net> <49D142AC.8090701@linux.intel.com>
In-Reply-To: <49D142AC.8090701@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903311533.16684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Arjan van de Ven wrote:
> Hans-Peter Jansen wrote:
> > Am Freitag, 27. März 2009 schrieb Linus Torvalds:
> > 
> > I always wonder, why Arjan does not intervene for his kerneloops.org 
> > project, since your approach opens a window of uncertainty during the merge 
> > window when simply using git as an efficient fetch tool.
> 
> I would *love* it if Linus would, as first commit mark his tree as "-git0"
> (as per snapshots) or "-rc0". So that I can split the "final" versus
> "merge window" oopses.

FWIW, that would also be useful for tracking regressions.

Thanks,
Rafael
