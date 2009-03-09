Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZCIU2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZCIU2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZCIU2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:28:24 -0400
Received: from exhub015-4.exch015.msoutlookonline.net ([207.5.72.96]:50837
	"EHLO EXHUB015-4.exch015.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbZCIU2X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:28:23 -0400
From: Stuart Xu <sxu@soleranetworks.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 9 Mar 2009 13:25:50 -0700
Subject: Where to get a Kernel tree with KGDB patched? -- help needed
Thread-Topic: Where to get a Kernel tree with KGDB patched? -- help needed
Thread-Index: AQHJoPWWqT8cj3jW/ESeGeIz5tGf9A==
Message-ID: <395C6DBC66158B4CA921D1A81BB7BE7CD03C8E44@EXVMBX015-1.exch015.msoutlookonline.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

>From online discussions, it seems that the linux 2.6 tree has included KGDB.  Anyone can tell me where and how to get such a kernel tree (preferably 2.6.27 ) that with KGDB patched already?

I tried to use git-checkout, but got a error:

git-checkout git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus
fatal: Not a git repository

Thanks,

Stuart

The information in this e-mail and in any attachments is confidential and may be privileged.  If you are not the intended recipient, please destroy this message, delete any copies held on your systems and notify the sender immediately.  You should not retain copy or use this e-mail for any purpose, nor disclose all or any part of its content to any other person.
