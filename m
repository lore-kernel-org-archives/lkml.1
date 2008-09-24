Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbYIXGCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbYIXGCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 02:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYIXGCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 02:02:33 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:36370 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYIXGCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 02:02:33 -0400
Message-ID: <48D9D7EF.9030604@davidnewall.com>
Date: Wed, 24 Sep 2008 15:32:23 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: airlied@gmail.com, jkosina@suse.cz, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <20080922.185902.80812984.davem@davemloft.net>	<alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>	<21d7e9970809231403wf766660u39908aca70548ca7@mail.gmail.com> <20080923.150559.34795136.davem@davemloft.net>
In-Reply-To: <20080923.150559.34795136.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Right now we don't have any real leads, so data acquisition is really
> important at this phase.

Isn't this reliably reproducible?  Assuming yes, Intel are such swell
guys that you might ask them to ship a few dozen cards to you to break
until you've tracked down the problem.  I mean, it's a lot easier to
find this sorts of fault when you can see it first hand than trying to
guess from third parties' reports, isn't it?  For some reasonable value
of "you", that so.
