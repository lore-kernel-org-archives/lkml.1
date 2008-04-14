Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbYDNNCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbYDNNCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYDNNCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:02:36 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:46705 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYDNNCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:02:35 -0400
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 09:02:35 EDT
From: Mikael Starvik <mikael.starvik@axis.com>
To: "'Adrian Bunk'" <bunk@kernel.org>,
       "bzolnier@gmail.com" <bzolnier@gmail.com>,
       Jesper Nilsson <Jesper.Nilsson@axis.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Apr 2008 14:50:19 +0200
Subject: RE: status of ETRAX_IDE?
Thread-Topic: status of ETRAX_IDE?
Thread-Index: AcidmFFZ3C9edvviSRmnGJvN77MelwAlak+A
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D050D3FB020@xmail3.se.axis.com>
In-Reply-To: <20080413183629.GA21204@cs181133002.pp.htv.fi>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can remove it for now and we will resubmit a new if/when we get around
to fix it.

/Mikael

-----Original Message-----
From: Adrian Bunk [mailto:bunk@kernel.org]
Sent: Sunday, April 13, 2008 8:36 PM
To: bzolnier@gmail.com; Mikael Starvik; Jesper Nilsson
Cc: dev-etrax; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: status of ETRAX_IDE?


ETRAX_IDE was marked as broken last year with the comment
"it doesn't even compile currently".

Is there some not yet merged update pending that will make it usable
again or should I send a patch to remove it?

cu
Adrian

--

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

