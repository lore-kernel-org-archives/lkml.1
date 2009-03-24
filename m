Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZCXFLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZCXFLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZCXFLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:11:05 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:47935 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZCXFLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:11:04 -0400
Message-ID: <49C86C76.70006@msgid.tls.msk.ru>
Date: Tue, 24 Mar 2009 08:15:34 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Phillip Lougher <phillip@lougher.demon.co.uk>
CC: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       squashfs-devel@lists.sourceforge.net
Subject: Re: Squashfs 4.0 tools
References: <20090323180808.2c2ef1a7@nehalam> <49C847C6.4030904@lougher.demon.co.uk>
In-Reply-To: <49C847C6.4030904@lougher.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:
> Stephen Hemminger wrote:
>> It is great that squashfs is finally in mainline kernel. But the
>> squashfs tools are tightly bound to the version of the squashfs 
>> filesystem.
[]
> I have been working on the 4.0 squashfs tools for the last couple of
> months making them (mksquashfs and unsquashfs) ready for a supported
> release.  Now that Linux 2.6.29 has been released (3 hours ago), I
> need to make this release ASAP, which as everything is almost finished,
> should be sometime this week.

By the way, with this on-disk format change, is there a way to get
4.0 fs code working with 2.6.27 (long-time-stable) kernel?  I tried
to compile it on 2.6.27 but it fails due to some API changes and I'm
not that deep into kernel to fix it...

Thanks!
