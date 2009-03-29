Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZC2UzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZC2UzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbZC2Uyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:54:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43861
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756939AbZC2Uyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:54:53 -0400
Date: Sun, 29 Mar 2009 13:54:41 -0700 (PDT)
Message-Id: <20090329.135441.198148384.davem@davemloft.net>
To: ogerlitz@voltaire.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: error building Linus tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0903292332480.31630@zuben.voltaire.com>
References: <Pine.LNX.4.64.0903292332480.31630@zuben.voltaire.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Or Gerlitz <ogerlitz@voltaire.com>
Date: Sun, 29 Mar 2009 23:36:47 +0300 (IDT)

> Building Linus tree with gcc 4.1.1 on an x86_64 system based on RHEL 5
> I run into the following error:

You need to use gcc-4.1.2 or later to correctly compile the kernel.
