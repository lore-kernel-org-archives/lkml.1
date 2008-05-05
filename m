Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbYEEUII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbYEEUII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYEEUHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:07:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59859
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753930AbYEEUHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:07:55 -0400
Date: Mon, 05 May 2008 13:07:55 -0700 (PDT)
Message-Id: <20080505.130755.216189613.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: china email failures...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Folks, if you have friends in China, you may let them know
that we've been increasing seeing site-wide bounce problems
lasting days here at vger that require us to remove lots of
people from the lists.

This isn't isolated to one or two sites, it's been seen for
anything from yahoo.com.cn to fujitsu.com.cn

The error is always the same:

	User not local; please try <forward-path>

and every recipient at the site fails this way.

I don't know what causes this, or why it's seemingly only
hitting sites in China.  But when it happens I have absolutely
no way to contact the people who I have to unsubscribe because
my emails to them fail in a similar way.

