Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbXHTO30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbXHTO30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbXHTO3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:29:18 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:3478 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754898AbXHTO3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:29:17 -0400
Message-ID: <46C9A542.7020902@cfl.rr.com>
Date: Mon, 20 Aug 2007 10:29:22 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
References: <900404.40407.qm@web52501.mail.re2.yahoo.com>
In-Reply-To: <900404.40407.qm@web52501.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2007 14:29:22.0689 (UTC) FILETIME=[807EEF10:01C7E336]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15368.001
X-TM-AS-Result: No--11.585200-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> No Al, there isn't any shortage of arrogance here.
> 
> Let me try to repeat what I'm talking about as simply
> as I can.
> 
> First - I'm describing a kind of functionality and
> suggesting Linux should have it. I know a lot of it
> can be done because much of what I'm suggesting is
> already working in Windows and Netware.

Let's not get confused here... ._I_ am suggesting a feature that windows 
and netware have done already, that being inheritable acls.  YOU 
suggested that permissions be configurable based on pattern matching on 
the name of the file.

