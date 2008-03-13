Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYCMXTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYCMXTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbYCMXTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:19:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53386 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757563AbYCMXTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:19:18 -0400
X-Sasl-enc: 2LpEZNywQWiNYaLRktq02j8FMKR7bQ3K+wyy+dmYNkyk 1205448926
Date: Thu, 13 Mar 2008 19:55:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080313225520.GF30864@khazad-dum.debian.net>
References: <20080312133529.GB21290@khazad-dum.debian.net> <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net> <20080313120514.GH17940@kernel.dk> <20080313122344.GD27873@ics.muni.cz> <20080313124633.GS17940@kernel.dk> <20080313125503.GE27873@ics.muni.cz> <20080313125933.GT17940@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313125933.GT17940@kernel.dk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Jens Axboe wrote:
> On Thu, Mar 13 2008, Lukas Hejtmanek wrote:
> > On Thu, Mar 13, 2008 at 01:46:33PM +0100, Jens Axboe wrote:
> > > They do not generate any events, xev reports nothing. The ThinkVantage
> > > button doesn't generate any events either.
> > 
> > what about BIOS upgrade? I think this really should work.
> 
> The BIOS isn't that old, probably updated it a couple of months ago.

On a T61/X61 Thinkpad, anything but the very latest BIOS is too old.  They
have been modifying the BIOS in areas that are directly related to Linux
support.

> > Ahh, maybe you are facing EC problems? Are you using just stock vanila
> > kernel or some additional patches?

EC problems anywhere in the entire ACPI subsystem can, and have, caused
weird thinkpad-acpi issues.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
