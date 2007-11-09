Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbXKICV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbXKICV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 21:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbXKICVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 21:21:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58642 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532AbXKICVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 21:21:48 -0500
Message-ID: <4733C460.202@austin.rr.com>
Date: Thu, 08 Nov 2007 20:22:24 -0600
From: Steve French <smfrench@austin.rr.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, v@iki.fi
Subject: Re: smbfs/cifs large file support history?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Does anyone remember when linux smbfs (or cifs) gained large file 
> (>2GB, >4GB) file support?

The Linux CIFS client implementation has always had large file support (cifs.ko was added to the kernel first in 2.5.42), although of course some old server's do not support large (> 2GB) files.

I thought smbfs added it late in the 2.4 series, but don't remember, it might have been in 2.5.


