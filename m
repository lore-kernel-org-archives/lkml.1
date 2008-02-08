Return-Path: <linux-kernel-owner+w=401wt.eu-S933224AbYBHG1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbYBHG1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 01:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYBHG1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 01:27:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41704
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbYBHG1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 01:27:00 -0500
Date: Thu, 07 Feb 2008 22:27:30 -0800 (PST)
Message-Id: <20080207.222730.61110620.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       isdn4linux@listserv.isdn4linux.de, kkeil@suse.de, jgarzik@pobox.com
Subject: Re: [PATCH] isdn: fix section mismatch warning in enpci_card_msg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080208055833.GA26183@uranus.ravnborg.org>
References: <1201873364-13475-3-git-send-email-sam@ravnborg.org>
	<20080207.182040.196977279.davem@davemloft.net>
	<20080208055833.GA26183@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 8 Feb 2008 06:58:33 +0100

> Hi David - did you apply only this
> or all 5 patches?
> I can resend if you prefer with Karsten's ack included.

Only this one, I don't have the others so feel free to send
thos.

> PS. Do you usual take isdn patches?

Lately that has been the case.
