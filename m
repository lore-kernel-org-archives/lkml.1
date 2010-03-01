Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0CAR7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:59:32 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:50619 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0CAR72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:59:28 -0500
Date: Mon, 01 Mar 2010 12:59:03 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Anisse Astier <anisse@astier.eu>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Harald Welte <laforge@gnumonks.org>,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Mattia Dongili <malattia@linux.it>, Peter Feuerer <peter@piie.net>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 01/14] MAINTAINERS: update drivers/platform/x86 information
In-reply-to: <71cd59b01002261353w53fea6cax146acfd18e87636@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1003011255030.4281@localhost.localdomain>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
 <1267197527-18062-2-git-send-email-mjg@redhat.com>
 <71cd59b01002261353w53fea6cax146acfd18e87636@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Corentin Chary wrote:

> On Fri, Feb 26, 2010 at 4:18 PM, Matthew Garrett <mjg@redhat.com> wrote:

> > Add a new mailing list (platform-driver-x86@vger.kernel.org)

> Ok,
> Should I re-send the big asus-laptop series I sent to Len (not already
> in acpi tree) and send it back to you so it can be merged in platform-driver-x86 ?

It looks like Matthew didn't send this up, so I've appended it
to an asus branch in my tree (I had Roel Kluin's "remove duplicate 
comparison" patch sitting in there).

Matthew,
Unless you object, I'll send Corentin's asus-laptop cleanup
upstream with my treek.

thanks,
Len Brown, Intel Open Source Technology Center
