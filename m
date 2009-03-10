Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZCJWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZCJWqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZCJWqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:46:04 -0400
Received: from shiva.jussieu.fr ([134.157.0.129]:59765 "EHLO shiva.jussieu.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbZCJWqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:46:03 -0400
X-Greylist: delayed 2285 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2009 18:46:02 EDT
X-Ids: 166
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Andy Grover <andy.grover@oracle.com>
Subject: RDS: no freely available protocol specification?
From: Juliusz Chroboczek <Juliusz.Chroboczek@pps.jussieu.fr>
Date: Tue, 10 Mar 2009 23:07:45 +0100
Message-ID: <7i63ihm3pq.fsf@lanthane.pps.jussieu.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (shiva.jussieu.fr [134.157.0.166]); Tue, 10 Mar 2009 23:07:47 +0100 (CET)
X-Miltered: at jchkmail.jussieu.fr with ID 49B6E4B2.007 by Joe's j-chkmail (http : // j-chkmail dot ensmp dot fr)!
X-j-chkmail-Enveloppe: 49B6E4B2.007/134.157.168.1/hydrogene.pps.jussieu.fr/hydrogene.pps.jussieu.fr/<Juliusz.Chroboczek@pps.jussieu.fr>
X-j-chkmail-Score: MSGID : 49B6E4B2.007 on jchkmail.jussieu.fr : j-chkmail score : . : R=. U=. O=. B=0.012 -> S=0.012
X-j-chkmail-Status: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am a little worried about the Reliable Datagram Sockets (RDS), which are
currently in the process of being merged into the kernel.  I've checked the
latest Interned-Drafts index, I've tried searching the web, and I cannot
find a freely available protocol specification.  (I've been unable to check
the documentation section of the oss.oracle.com site, which requires
a password with no way to register visible to my tired eyes.)

I am wondering whether we wish to encourage the use of proprietary
(undocumented) protocols, and I wish that the kernel crowd should really
try to put some pressure on the Oracle guys to get the RDS protocol spec
published as an RFC, or at the very least submitted as an Internet Draft,
before it is released as part of the Linux kernel.

                                        Juliusz Chroboczek
