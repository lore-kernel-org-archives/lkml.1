Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYIWWGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYIWWGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYIWWGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:06:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56486
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYIWWGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:06:12 -0400
Date: Tue, 23 Sep 2008 15:05:59 -0700 (PDT)
Message-Id: <20080923.150559.34795136.davem@davemloft.net>
To: airlied@gmail.com
Cc: jkosina@suse.cz, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970809231403wf766660u39908aca70548ca7@mail.gmail.com>
References: <20080922.185902.80812984.davem@davemloft.net>
	<alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
	<21d7e9970809231403wf766660u39908aca70548ca7@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Wed, 24 Sep 2008 07:03:53 +1000

> I have no evidence in my logs of a graphics panic, but I do do a lot
> of graphics devel,
> so it might be a possiblity but I'd hate to handwave it away at that.

Let's not handwave, but rather try to figure out if that is part of
the pattern.

Right now we don't have any real leads, so data acquisition is really
important at this phase.
