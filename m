Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbXJGWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbXJGWgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 18:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXJGWgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 18:36:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26045 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbXJGWgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 18:36:08 -0400
Date: Sun, 7 Oct 2007 15:32:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: "Miguel Ojeda" <maxextreme@gmail.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Message-Id: <20071007153228.8d45a0b2.randy.dunlap@oracle.com>
In-Reply-To: <200710071656.02471.rob@landley.net>
References: <1191528247.13580.11.camel@grianne>
	<200710051126.50816.rob@landley.net>
	<653402b90710051601x347924d3j34b5ec740c39e81c@mail.gmail.com>
	<200710071656.02471.rob@landley.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2007 16:56:01 -0500 Rob Landley wrote:

> On Friday 05 October 2007 6:01:10 pm Miguel Ojeda wrote:
> > > *shrug*  That doesn't mean my objections are important to anyone else,
> > > just that I don't personally see any reason to be enthusiastic about this
> > > patch.
> >
> > Take a look to other suggested changes, maybe you like some of them
> > and you will have found a reason to be enthusiastic :)
> 
> Is there any way to serialize the changes?  It's hard to review a big lump.

There are also parts of the patch that could be submitted
independently of any message-logging API changes.

---
~Randy
