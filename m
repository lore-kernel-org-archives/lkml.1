Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbXIZU4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbXIZU4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXIZUzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:55:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:33550 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbXIZUzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=D9rigSSiLqkNp3qphcGBFfNSGDDQGJ68vuGCY/sFpKCrmnL6USQ8I9fZv23nYN7ymbqi7YVE/zXleHX6CzqRrvDeTJzBZeWOx1ESXJBDr5kiMaYD8Y7xyBfgltR/rNPQ+/DL/RYTH2epID1iMf6YzcfWNOeZ/RWWDa8Qyqek5mk=
Message-ID: <46FAC753.50707@gmail.com>
Date: Wed, 26 Sep 2007 22:55:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristof Provost <Kristof@provost-engineering.be>
CC: mahamuni ashish <ash_lkp@yahoo.co.in>, linux-kernel@vger.kernel.org
Subject: Re: No linux/module.h
References: <120377.13385.qm@web7807.mail.in.yahoo.com> <20070926202529.GB25724@luggage>
In-Reply-To: <20070926202529.GB25724@luggage>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2007 10:25 PM, Kristof Provost wrote:
> On 2007-09-26 11:29:33 (+0100), mahamuni ashish <ash_lkp@yahoo.co.in> wrote:
>> I am writing simple kernel module.
>> I have included linux/module.h
>> compiler gives me error that no such file, I also
>> searched it on my machine.
>> It really doesn't exist. I am using fedora 6.
>> How do I install required libraries.
> I suspect you either have an incorrect makefile or you don't have the
> kernel source code on your system. The header file can be found in the
> kerel source: include/linux/module.h

He needs kernel-devel, I guess.

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
