Return-Path: <linux-kernel-owner+w=401wt.eu-S1764370AbXHDJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764370AbXHDJh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 05:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbXHDJhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 05:37:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbXHDJhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 05:37:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gert Robben <lkml@gert.robben.nu>
Subject: Re: PROBLEM: snd-au8830: dead after software suspend
Date: Sat, 4 Aug 2007 11:46:18 +0200
User-Agent: KMail/1.9.5
Cc: alsa-devel@alsa-project.org, mjander@embedded.cl,
       linux-kernel@vger.kernel.org
References: <46B3A4F5.2000708@gert.robben.nu> <46B3C44D.7020801@gert.robben.nu> <46B3CDA0.90804@gert.robben.nu>
In-Reply-To: <46B3CDA0.90804@gert.robben.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041146.18682.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 August 2007 02:51, Gert Robben wrote:
> >>> Have you reported this to the ALSA people?
> >> No, I thought this might as well be something for PCI or PM people, and 
> >> I expected some ALSA people are also reading this list.
> >> If not, where else should I report this exactly?
> > alsa-devel [...] the author of the driver
> Done (original message below). Thanks again :)

You also may want to file a bug at http://bugzilla.kernel.org .

If you decide to do that, please file it as
"Power Management"->Hibernation/Suspend bug, I'll redirect it to the ALSA
people.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
