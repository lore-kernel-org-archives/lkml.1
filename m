Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZBETIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZBETIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZBETIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:08:12 -0500
Received: from wind.enjellic.com ([209.243.13.15]:57207 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZBETIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:08:11 -0500
X-Greylist: delayed 1558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 14:08:10 EST
Message-Id: <200902051841.n15IfatX032223@wind.enjellic.com>
From: greg@enjellic.com
Date: Thu, 5 Feb 2009 12:41:36 -0600
In-Reply-To: "Rafael J. Wysocki" <rjw@sisk.pl>
       "[Bug #12208] uml is very slow on 2.6.28 host" (Feb  4, 11:58am)
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.5 10/14/92)
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 4, 11:58am, "Rafael J. Wysocki" wrote:
} Subject: [Bug #12208] uml is very slow on 2.6.28 host

Good day to everyone.

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> Subject		: uml is very slow on 2.6.28 host
> Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> Date		: 2008-12-12 9:35 (55 days old)
> References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4

I'm not convinced its as fast as it should be on 2.6.27.

I'm currently testing 2.6.27.14 hosts on several different pieces of
hardware with a common 2.6.23.17 guest.

Currently the UML guest on my desktop machine which is an 11 year old
300Mhz dual-processor Pentium-II with 256MB of RAM running 2.6.22.14
is giving a rather sound performance drubbing to the identical UML
guest running on a 2.5GHZ dual-quad 5420 with 16GB of RAM running a
32-bit 2.6.27.14.

}-- End of excerpt from "Rafael J. Wysocki"

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"There's no such thing as a wizard who minds his own business."
                                -- Berengis the Black Court Mage
                                   to the Earls Caeline
