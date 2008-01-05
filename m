Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYAEUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYAEUaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbYAEUap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:30:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:4116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbYAEUap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=WagmeL2yi64wS3ekDL9P7PNE0CJFoV3EZWZj+nAJvK3RYakfQGmB6xocjCQfoxeGkHOThZ0/pYmRX3ebAwVbj9p2bRkCsCeEKPHOZYaH551YVM1QZGGB9OIZd1bftpjgnrsMBWPei7CYsqm50aYq0BGVHNnHaxheQhNsGR1qwjc=
Date: Sun, 6 Jan 2008 00:30:34 +0400
From: Alexander Shaduri <ashaduri@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080106003034.15a75d4c@linux.localdomain>
In-Reply-To: <20080105201622.GL27894@ZenIV.linux.org.uk>
References: <20080104213812.20268840@linux.localdomain>
	<20080105091012.GG27894@ZenIV.linux.org.uk>
	<20080105173601.75370546@linux.localdomain>
	<18303.38257.850625.70108@harpo.it.uu.se>
	<20080105184656.52b1f7d3@linux.localdomain>
	<20080105201622.GL27894@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Get a serial console?  Take another box, plug e.g. pl2303-based
> usb-to-serial (several bucks these days) into it, stick null-modem
> convertor (ditto) on its serial end and attach to ttyS0 on the
> victim.  console=ttyS0 on victim, something like minicom on watcher
> and tell it to capture log into file...

I will try that (as soon as I acquire the necessary parts).

Thanks,
Alexander
