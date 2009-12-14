Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZLNPzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZLNPzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 10:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbZLNPzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 10:55:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:59168 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757534AbZLNPzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 10:55:23 -0500
X-Authenticated: #3453474
X-Provags-ID: V01U2FsdGVkX19a9G58nBNaTNZWQtcNmfli7N5xkJoJzYCf2Snrm/
	PL2wxZrOFCjWx0
Message-ID: <4B265FEC.6060503@gmx.net>
Date: Mon, 14 Dec 2009 16:55:24 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
Subject: Bug 14594: fix for 2.6.31.8 ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug 14594 has been fixed with commit
e29d4363174949a7a4e46f670993d7ff43342c1c for 2.6.32 a month ago, but
2.6.28 - 2.6.31.7 are still affected.
Any plans to apply this at least for 2.6.31.8, too ?

Regards,
Frank Schaefer
