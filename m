Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbXITFpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbXITFpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXITFpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:45:04 -0400
Received: from sslsrv.de ([62.75.159.123]:45535 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXITFpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:45:02 -0400
Message-ID: <39168.193.171.152.61.1190267089.squirrel@webmail.marek.priv.at>
In-Reply-To: <20070919180544.GA11860@c2.user-mode-linux.org>
References: <200709181714.34035@x5> <200709191443.24158@x5>
    <20070919085032.dd5c1732.randy.dunlap@oracle.com>
    <200709191817.51921@x5>
    <20070919180544.GA11860@c2.user-mode-linux.org>
Date: Thu, 20 Sep 2007 07:44:49 +0200 (CEST)
Subject: Re: UML dead with current -git?
From: "Ph. Marek" <philipp@marek.priv.at>
To: "Jeff Dike" <jdike@addtoit.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-4.fc1.1.legacy
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeff,

> On Wed, Sep 19, 2007 at 06:17:51PM +0200, Philipp Marek wrote:
>> How about that?
>> 	readlink include/asm
>> returns
>> 	asm-um
>> in my case, so I only have to strip the "asm-" part ...
>
> It doesn't handle O= directories...
Sorry, I don't understand you. What are "0=" directories? Do you mean that
if there's no include/ directory?


Well, I guess that there are non-obvious corner cases in the include/asm
symlink usage, that amateurs simply do not know ...


Regards,

Phil


-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
