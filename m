Return-Path: <linux-kernel-owner+w=401wt.eu-S934248AbXFFNBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbXFFNBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762162AbXFFNBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:01:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:55565 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759545AbXFFNBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:01:33 -0400
X-Authenticated: #228032
X-Provags-ID: V01U2FsdGVkX1/9q4x6Rkr9W4etw2VLzWYyd87W9DeyytD3INvOuN
	yEp12nkqMBeAeu
Date: Wed, 6 Jun 2007 15:01:29 +0200
From: Simon Peter <simon.peter@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Kernel Timers
Message-Id: <20070606150129.49936f60.simon.peter@gmx.de>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see two kernel timer interfaces: The standard and the high-resolution
timers. Are there any more? Is the whole kernel using these two
interfaces?

Thanks,
Simon
