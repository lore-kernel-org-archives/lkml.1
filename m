Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbXCULBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbXCULBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXCULBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:01:16 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20187 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXCULBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:01:15 -0400
Message-ID: <46011075.6050608@tls.msk.ru>
Date: Wed, 21 Mar 2007 14:01:09 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Thunderbird 1.5.0.5 (X11/20060813)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: [patch 2.6.21-rc4-git] SCSI newstyle hotplug/coldplug support
References: <200703201736.09280.david-b@pacbell.net>
In-Reply-To: <200703201736.09280.david-b@pacbell.net>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> This teaches scsi devices how to support "new style" hotplug/coldplug:
> using a modalias sysfs attribute for coldplug, and MODALIAS environment
> variable for hotplug.

How this is different from http://marc.info/?t=115204542200002&r=1&w=2 and
earlier attempts to do the same?

/mjt
