Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXLEGCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXLEGCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 01:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXLEGBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 01:01:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbXLEGBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 01:01:52 -0500
Date: Tue, 04 Dec 2007 22:01:50 -0800 (PST)
Message-Id: <20071204.220150.141230758.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: daniel.lezcano@free.fr, greearb@candelatech.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org, lkml@rtr.ca,
       shemminger@linux-foundation.org
Subject: Re: namespace support requires network modules to say "GPL"
From: David Miller <davem@davemloft.net>
In-Reply-To: <m163zexrqi.fsf@ebiederm.dsl.xmission.com>
References: <47544896.7070101@candelatech.com>
	<475451B1.1030006@free.fr>
	<m163zexrqi.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 04 Dec 2007 11:03:01 -0700

> I am confused.  I don't see a path forward that feels right.

Eric, instead of writing a book about how you feel, look
at the simple facts and resolve this quickly.

You added a new key, the namespace, to the looking up of
network objects.

Big deal.

That does not imply a change in licensing for the interfaces
where you added that new aspect of the key to the argument
list.

This symbol licensing decision was not your's to make, so you must
revert the new licensing change you are enforcing upon everyone.

I want a de-GPL patch in my mailbox from you within the next 24 hours
or I will code one up myself.  This is getting beyond rediculious.

My patience is completely gone on this matter, resolve this now.

Thanks.
