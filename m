Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYCMNNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYCMNNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYCMNNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:13:39 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20399 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923AbYCMNNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:13:38 -0400
Date: Thu, 13 Mar 2008 14:13:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080313131334.GV17940@kernel.dk>
References: <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net> <20080313120514.GH17940@kernel.dk> <20080313122344.GD27873@ics.muni.cz> <20080313124633.GS17940@kernel.dk> <20080313125503.GE27873@ics.muni.cz> <20080313125933.GT17940@kernel.dk> <20080313130934.GG27873@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313130934.GG27873@ics.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13 2008, Lukas Hejtmanek wrote:
> On Thu, Mar 13, 2008 at 01:59:34PM +0100, Jens Axboe wrote:
> > The BIOS isn't that old, probably updated it a couple of months ago.
> 
> I use the latest BIOS for my T61 and it just works. At least the event is
> generated either for acpid or for Xserver.

This is an x60, so there may be other differences there.

-- 
Jens Axboe

