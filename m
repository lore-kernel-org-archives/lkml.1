Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYC1E4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYC1E4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYC1E4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:56:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56825
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbYC1E4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:56:22 -0400
Date: Thu, 27 Mar 2008 21:56:22 -0700 (PDT)
Message-Id: <20080327.215622.103233305.davem@davemloft.net>
To: rct@frus.com
Cc: lkml@rtr.ca, jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org
Subject: Re: 2.6.25-rc7: Ugh.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080328044258.7AA98DBA2@gherkin.frus.com>
References: <20080327.201202.163153963.davem@davemloft.net>
	<20080328044258.7AA98DBA2@gherkin.frus.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: rct@frus.com (Bob Tracy)
Date: Thu, 27 Mar 2008 23:42:58 -0500 (CDT)

> I don't understand this claim.  On what incredibly fast piece of iron
> can you possibly do between 8 and 16 kernel builds (the range I've
> encountered when I do the "git bisect" dance), boot each one, and
> evaluate the results in so small a period of time?

Builds are just over a minute on my box.  I can do a full
kernel build plus reboot cycle in under 2 minutes.
