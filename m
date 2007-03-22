Return-Path: <linux-kernel-owner+w=401wt.eu-S965388AbXCVTON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388AbXCVTON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXCVTON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:14:13 -0400
Received: from gherkin.frus.com ([192.158.254.49]:50673 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965388AbXCVTOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:14:12 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
In-Reply-To: <1174588512.5662.3.camel@localhost.localdomain> "from john stultz
 at Mar 22, 2007 11:35:12 am"
To: john stultz <johnstul@us.ibm.com>
Date: Thu, 22 Mar 2007 13:14:10 -0600 (CST)
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070322191410.ECCBFDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> Try this patch and let me know if it does the right thing.

Will do.  I'll report back in a few hours.

> Although I do
> still need to dig a bit on the PIT hang issue.

Any chance this might be related to the APIC issues currently being
discussed in other threads?

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
