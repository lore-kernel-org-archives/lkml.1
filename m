Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZCJXKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZCJXKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZCJXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:10:21 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:38033 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZCJXKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:10:20 -0400
Message-ID: <49B6F348.8010507@oracle.com>
Date: Tue, 10 Mar 2009 16:10:00 -0700
From: Andy Grover <andy.grover@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Juliusz Chroboczek <Juliusz.Chroboczek@pps.jussieu.fr>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       RDS Devel <rds-devel@oss.oracle.com>
Subject: Re: RDS: no freely available protocol specification?
References: <7i63ihm3pq.fsf@lanthane.pps.jussieu.fr>
In-Reply-To: <7i63ihm3pq.fsf@lanthane.pps.jussieu.fr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49B6F34C.025D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juliusz Chroboczek wrote:
> I am a little worried about the Reliable Datagram Sockets (RDS), which are
> currently in the process of being merged into the kernel.  I've checked the
> latest Interned-Drafts index, I've tried searching the web, and I cannot
> find a freely available protocol specification.  (I've been unable to check
> the documentation section of the oss.oracle.com site, which requires
> a password with no way to register visible to my tired eyes.)

Look in net-next tree, Documentation/networking/rds.txt.

> I am wondering whether we wish to encourage the use of proprietary
> (undocumented) protocols, and I wish that the kernel crowd should really
> try to put some pressure on the Oracle guys to get the RDS protocol spec
> published as an RFC, or at the very least submitted as an Internet Draft,
> before it is released as part of the Linux kernel.

I thought "rough consensus and running code" was the IETF credo? We've
provided running code, some documentation, and an active maintainer and
mailing list. If you're interested in getting an RFC drafted for RDS,
then I invite you to start work on one. I also will accept patches to
improve the documentation.

See how this works?

Regards -- Andy

