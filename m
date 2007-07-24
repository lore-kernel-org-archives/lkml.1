Return-Path: <linux-kernel-owner+w=401wt.eu-S1763062AbXGXHvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763062AbXGXHvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXGXHvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:51:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:41514 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbXGXHvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NpM6EU66EFajVD4MMYShB6L/9hnHoInC5hCZFKv7BalbZaRpF9HKXSsSztksxs9A97plgXmGyFPoQIY9qIOL59fsWDb6CD5n/1aYI4Bagk/3LUBxxPqfZSmAFNKI2uY9UgUj0rWT6GK+wp10dXfzw5fTc4cjaHeFUrOjMAH9ssc=
Message-ID: <46A5AEE0.1070202@googlemail.com>
Date: Tue, 24 Jul 2007 09:48:48 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: i386 section mismatch warnings
References: <46A5536E.6010606@garzik.org> <20070724014512.GO21668@ftp.linux.org.uk>
In-Reply-To: <20070724014512.GO21668@ftp.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, Jul 23, 2007 at 09:18:38PM -0400, Jeff Garzik wrote:
>> make allmodconfig on i386:
>>
>> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to 
> 
> Ignore.  vmlinux.o ones are interesting; so are ones in modules.
> vmlinux ones are either duplicates of vmlinux.o or false positives.

allyesconfig has a lot Section mismatch warnings , are these false positive too ?


http://lkml.org/lkml/2007/7/22/312

Regards,

Gabriel C
