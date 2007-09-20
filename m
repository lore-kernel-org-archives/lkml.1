Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbXITFsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbXITFsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXITFsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:48:17 -0400
Received: from sslsrv.de ([62.75.159.123]:45990 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXITFsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:48:16 -0400
Message-ID: <41830.193.171.152.61.1190266958.squirrel@webmail.marek.priv.at>
In-Reply-To: <20070919104703.4c9d432f.randy.dunlap@oracle.com>
References: <200709181714.34035@x5> <200709191443.24158@x5>
    <20070919085032.dd5c1732.randy.dunlap@oracle.com>
    <200709191817.51921@x5>
    <20070919104703.4c9d432f.randy.dunlap@oracle.com>
Date: Thu, 20 Sep 2007 07:42:38 +0200 (CEST)
Subject: Re: UML dead with current -git?
From: "Ph. Marek" <philipp@marek.priv.at>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: "Philipp Marek" <philipp@marek.priv.at>, "Jeff Dike" <jdike@addtoit.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-4.fc1.1.legacy
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy!

> This doesn't work when there is no include/asm symlink.
Why? I specifically test for that, and tried it on my machine.
What's the bug?
ASMARCH should come out empty, and the ?= and $(or) should take care of
the rest ...

> It also didn't apply cleanly due to tab(s) being converted
> to spaces (but of course I fixed that part).
Yes, sorry. I'll try to attach inline next time.


Regards,

Phil

-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
