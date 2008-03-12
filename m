Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYCLTNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYCLTNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYCLTNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:13:24 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:25667 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCLTNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:13:23 -0400
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 15:13:23 EDT
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Date: Wed, 12 Mar 2008 19:52:41 +0100
User-Agent: PLD Linux KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jens Axboe <jens.axboe@oracle.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312133529.GB21290@khazad-dum.debian.net> <20080312135521.GE8141@ics.muni.cz>
In-Reply-To: <20080312135521.GE8141@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803121952.42666.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, Mar 12, 2008 at 10:35:29AM -0300, Henrique de Moraes Holschuh wrote:
> > You shouldn't need to do anything other than teach userspace to respond
> > to them, as they generate the proper KEY_* events.  If you are giving the
> > AML _OSI(Linux), at least...

I'm also seeing regression on my thinkpad z60m where with git tree (tested 
again with 2 days old git) "thinkvantage" button stopped working (pressing it 
was previously seen by some userspace kde which run konsole).

On 2.6.24 presses are seen.

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
