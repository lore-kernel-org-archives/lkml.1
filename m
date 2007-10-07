Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbXJGV4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbXJGV4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXJGV4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:56:08 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52083
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752547AbXJGV4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 17:56:07 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Miguel Ojeda" <maxextreme@gmail.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Date: Sun, 7 Oct 2007 16:56:01 -0500
User-Agent: KMail/1.9.6
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
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
References: <1191528247.13580.11.camel@grianne> <200710051126.50816.rob@landley.net> <653402b90710051601x347924d3j34b5ec740c39e81c@mail.gmail.com>
In-Reply-To: <653402b90710051601x347924d3j34b5ec740c39e81c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710071656.02471.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007 6:01:10 pm Miguel Ojeda wrote:
> > *shrug*  That doesn't mean my objections are important to anyone else,
> > just that I don't personally see any reason to be enthusiastic about this
> > patch.
>
> Take a look to other suggested changes, maybe you like some of them
> and you will have found a reason to be enthusiastic :)

Is there any way to serialize the changes?  It's hard to review a big lump.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
