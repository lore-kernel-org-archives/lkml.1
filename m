Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZBHWE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZBHWE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZBHV52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:57:28 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1096 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754720AbZBHV5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:57:25 -0500
Date: Sun, 8 Feb 2009 16:57:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Vegard Nossum <vegard.nossum@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [linux-pm] 2.6.29-rc4: Reported regressions from 2.6.28
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
Message-ID: <Pine.LNX.4.44L0.0902081652120.22400-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12668
> Subject		: USB flash disk surprise disconnect
> Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
> Date		: 2009-02-08 10:21 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=123408851821292&w=4

Is there any reason to think this is a regression rather than a 
one-time fluke?

If it really is a regression, additional debugging info would help.  
The log excerpt in the email report doesn't show anything that happened
prior to the disconnect.

Alan Stern

