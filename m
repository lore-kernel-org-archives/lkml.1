Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbXKDPyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbXKDPyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXKDPyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:54:43 -0500
Received: from mail.trixing.net ([87.230.125.58]:33162 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbXKDPyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:54:43 -0500
Message-ID: <472DEB2A.5010804@l4x.org>
Date: Sun, 04 Nov 2007 16:54:18 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <472B9479.7040105@l4x.org> <15675.1193753820@redhat.com> <4726337B.1080608@l4x.org> <4725B553.4060502@l4x.org> <4220.1193663179@redhat.com> <15712.1193753924@redhat.com> <15089.1194087529@redhat.com>
In-Reply-To: <15089.1194087529@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.106
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: Working frv toolchain?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Jan Dittmer <jdi@l4x.org> wrote:
> 
>> Hrm, that gets me further, but one of the final stages fail:
> 
> What's your configuration?

I just do:

make HOSTCC=gcc-4.0 ARCH=frv CROSS_COMPILE=frv-linux-gnu- O=... \
      defconfig
make HOSTCC=gcc-4.0 ARCH=frv CROSS_COMPILE=frv-linux-gnu- O=...

As I said it is for the automatic compile testing at l4x.org/k/

Thanks,

Jan
