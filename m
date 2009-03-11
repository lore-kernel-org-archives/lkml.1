Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZCKAEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZCKAEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZCKAEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:04:38 -0400
Received: from shiva.jussieu.fr ([134.157.0.129]:58537 "EHLO shiva.jussieu.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZCKAEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:04:37 -0400
X-Ids: 166
To: Andy Grover <andy.grover@oracle.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       RDS Devel <rds-devel@oss.oracle.com>
Subject: Re: RDS: no freely available protocol specification?
References: <7i63ihm3pq.fsf@lanthane.pps.jussieu.fr>
	<49B6F348.8010507@oracle.com>
From: Juliusz Chroboczek <Juliusz.Chroboczek@pps.jussieu.fr>
Date: Wed, 11 Mar 2009 01:04:28 +0100
In-Reply-To: <49B6F348.8010507@oracle.com> (Andy Grover's message of "Tue\, 10 Mar 2009 16\:10\:00 -0700")
Message-ID: <7iprgolyb7.fsf@lanthane.pps.jussieu.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (shiva.jussieu.fr [134.157.0.166]); Wed, 11 Mar 2009 01:04:30 +0100 (CET)
X-Miltered: at jchkmail.jussieu.fr with ID 49B7000D.003 by Joe's j-chkmail (http : // j-chkmail dot ensmp dot fr)!
X-j-chkmail-Enveloppe: 49B7000D.003/134.157.168.1/hydrogene.pps.jussieu.fr/hydrogene.pps.jussieu.fr/<Juliusz.Chroboczek@pps.jussieu.fr>
X-j-chkmail-Score: MSGID : 49B7000D.003 on jchkmail.jussieu.fr : j-chkmail score : . : R=. U=. O=. B=0.008 -> S=0.008
X-j-chkmail-Status: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply, Andy.

>> I've tried searching the web, and I cannot find a freely available
>> protocol specification.

> Look in net-next tree, Documentation/networking/rds.txt.

I cannot find a protocol description, let alone a full specification, in
this document.

>> I am wondering whether we wish to encourage the use of proprietary
>> (undocumented) protocols,

> I thought "rough consensus and running code" was the IETF credo?

I'm not the IETF, but it is my understanding that rough consensus is
achieved by writing protocol specifications, and submitting them as
Internet-Drafts.  (While some Internet-Drafts are destined to become
standards track RFCs after IETF consensus has been reached, many are only
submitted in order to stimulate discussion, and some only get submitted so
that they may become Informational RFCs.)

>From what I can gather from the very sparse documentation, RDS in its
current state cannot possibly achieve IETF consensus, for multiple reasons
(many of which I happen to disagree with -- but I'm not the IETF).  Still,
if Oracle find it useful, I'd like to see it published as an informational
RFC.

I'd have no objection to RDS being included in the Linux kernel without
IETF consensus, as long as the protocol is fully documented.

> If you're interested in getting an RFC drafted for RDS, then I invite you
> to start work on one. I also will accept patches to improve the
> documentation.
>
> See how this works?

Andy, please don't bully me.

                                        Juliusz
