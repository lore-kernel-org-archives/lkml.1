Return-Path: <linux-kernel-owner+w=401wt.eu-S1763532AbXK2VvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763532AbXK2VvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762589AbXK2Vu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:50:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47831 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754024AbXK2Vu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:50:56 -0500
Date: Thu, 29 Nov 2007 21:45:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, tvrtko.ursulin@sophos.com,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: Out of tree module using LSM
Message-ID: <20071129214527.1d62056c@the-village.bc.nu>
In-Reply-To: <1196365551.6473.103.camel@perihelion>
References: <20071128183040.GW8181@ftp.linux.org.uk>
	<OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
	<20071129173601.34273083@the-village.bc.nu>
	<2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com>
	<1196362612.6473.98.camel@perihelion>
	<2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
	<1196365551.6473.103.camel@perihelion>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jargon File in all its glory. And if you still think you could look for
> patterns, how about executable code that self-modifies in random ways
> but when executed as a whole actually has the functionality of fetchmail
> embedded within it? How would you guard against that?

Thats a problem for whoever writes the ESR detection tool and to what
level it works. The question for the kernel is how do we provide a
mechanism to allow (to some extent at least) this kind of tool to run.

Alan
