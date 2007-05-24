Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXEXGcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXEXGcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 02:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXEXGcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 02:32:46 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36707 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbXEXGcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 02:32:45 -0400
Message-ID: <465530E1.6050207@gmail.com>
Date: Thu, 24 May 2007 08:29:53 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>	<46541F65.9060507@msgid.tls.msk.ru>	<20070523100416.93835196.randy.dunlap@oracle.com>	<465492C8.9060003@gmail.com> <20070523135513.b3573f52.randy.dunlap@oracle.com> <46551A93.6050801@gmail.com> <46551DCC.1070104@oracle.com> <46551E87.1030700@gmail.com>
In-Reply-To: <46551E87.1030700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2007 07:11 AM, Rene Herman wrote:

>>> Okay. I would by the way not be against turning the timestamping off
>>> by default and turning it _on_ with a "timestamps" or "logtime" or 
>>> whatever option.

Yes I only now looked. Sorry, didn't realise that was how it already worked. 
CONFIG_PRINTK_TIME seems a little silly in that case but _someone_ thought 
it was worth spending an option on, so hey...

Rene.

