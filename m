Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbXBVIMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbXBVIMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXBVIMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:12:20 -0500
Received: from tag.witbe.net ([81.88.96.48]:36486 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbXBVIMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:12:19 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Patrick Ale'" <patrick.ale@gmail.com>,
       "'Vincent Legoll'" <vincent.legoll@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: libsata doesn't like bus without master
Date: Thu, 22 Feb 2007 09:12:02 +0100
Organization: AS2917.net
Message-ID: <033401c75659$251d8c40$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <8d158e1f0702211301n3d30f590t14b1501e418da7e0@mail.gmail.com>
Thread-Index: AcdV+4UBRCmwZ+D4SQ6//b86qt9bNQAXTvpA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> The first one got some debate as if it was legal to have a slave
> without a master and all and the last thing I saw written on this
> email that we (that is, the linux developers and the maintainers, I
> dont code anything other than 'Hello world' and even that might
> segfault) should support it and if we dont yet, fix it.

<please no flame war>

Just to add my $0.02 on this point : this could also be one of the problem
I'm facing on my machine right now, but the point is that Windows supports
it perfectly. At least that proves it can work, and it does work.

</please no flame war>

So, as far as I'm concerned, that sounds legal... Also, running old Linux IDE
code is no problem with a bus that only has a slave...

Regards,
Paul

