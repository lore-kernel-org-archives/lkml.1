Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXKQPM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXKQPM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 10:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXKQPMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 10:12:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:9262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbXKQPMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 10:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VCI2tHKMvaqNjhktYOEM2DX3zGEPt07U8FqtRo0XxIuhGFWa9KC10UeO4EJWsTUwf+9cbPNBsIz2Ni8HZfBSdtCgI3ik5TRoQwdj9EqcicXjRU1Oo86YM86knBO2e1g/omFdTuhz6ATNtpfr6q+WgbN1mRcrGnp5F2DJilu/dmI=
Message-ID: <473F04CB.70602@gmail.com>
Date: Sat, 17 Nov 2007 16:12:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <Pine.LNX.4.44L0.0711161058170.2738-100000@iolanthe.rowland.org> <473F03DF.4020306@gmail.com>
In-Reply-To: <473F03DF.4020306@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2007 04:08 PM, Jiri Slaby wrote:
> On 11/16/2007 05:10 PM, Alan Stern wrote:
>> If there's also a config 
>> option to prevent the console from being suspended, set it as well.  
> 
> no_suspend_console kernel parameter has no effect (why?).

Eh, no, this (/proc/cmdline):
ro root=/dev/md1 reboo1 vga=1 2 no_console_suspend

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
