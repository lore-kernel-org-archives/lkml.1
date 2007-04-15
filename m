Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbXDOVph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbXDOVph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 17:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXDOVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 17:45:37 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:42849 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753983AbXDOVpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 17:45:36 -0400
Message-ID: <46229CFD.6000506@gmail.com>
Date: Sun, 15 Apr 2007 23:45:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day napsal(a):
> ./drivers/char/Kconfig: tristate "Moxa SmartIO support (OBSOLETE)"

Yes, I'm going to add it to the schedule shortly -- will post patch with
correcting bad Kconfig info after some bugfixes of mxser_new.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

