Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbZD1QeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbZD1QeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZD1QeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:34:07 -0400
Received: from broadrack.ru ([195.178.208.66]:34965 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbZD1QeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:34:06 -0400
Date: Tue, 28 Apr 2009 20:33:56 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 2/3] w1: ds2760: add support for EEPROM read and write
Message-ID: <20090428163356.GA13843@ioremap.net>
References: <1240908902-24646-1-git-send-email-daniel@caiaq.de> <1240908902-24646-2-git-send-email-daniel@caiaq.de> <20090428150109.GA14209@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428150109.GA14209@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton.

On Tue, Apr 28, 2009 at 07:01:09PM +0400, Anton Vorontsov (avorontsov@ru.mvista.com) wrote:
> On Tue, Apr 28, 2009 at 10:55:01AM +0200, Daniel Mack wrote:
> > In order to modify the DS2762's status registers and to add support for
> > sleep mode, there is need for functions to write the internal EEPROM.
> > 
> > Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> > Cc: Matt Reimer <mreimer@vpop.net>
> > Cc: Anton Vorontsov <cbou@mail.ru>
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > ---
> 
> Evgeniy, don't mind if I take it via battery-2.6.git tree?

Looks good, ack!
Feel free to push both patches via battery tree when needed.

-- 
	Evgeniy Polyakov
