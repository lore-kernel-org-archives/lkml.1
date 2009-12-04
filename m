Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZLDMQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZLDMQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZLDMQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:16:36 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:47568 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbZLDMQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X5CmokTvs5VnXOFQXMbXbbxUik+jlgc5oVMvKZmL60a5uLk00ztXh2ooLJ2N/ozcOR
         tasWjaYJDQdel2bo/6/z+8dW28LYK+hoAda6AsWGdIPsggLmnbH53lrdbTNnGiOXP0GA
         9a/EelvWAxNF6p4/Q+gM0zNGBECtq9P0we544=
Message-ID: <4B18FDA3.5060601@gmail.com>
Date: Fri, 04 Dec 2009 07:16:35 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
References: <20091204194301.ca77fe40.sfr@canb.auug.org.au>
In-Reply-To: <20091204194301.ca77fe40.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Eric,
> 
> Today's linux-next merge of the sysctl tree got a conflict in
> net/ipv4/sysctl_net_ipv4.c between commit
> 519855c508b9a17878c0977a3cdefc09b59b30df ("TCPCT part 1c:
> sysctl_tcp_cookie_size, socket option TCP_COOKIE_TRANSACTIONS") from the
> net tree and commit f8572d8f2a2ba75408b97dc24ef47c83671795d7 ("sysctl
> net: Remove unused binary sysctl code") from the sysctl tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Hi, I'm not Eric, but it's my TCPCT patch -- is there something more
that I need to do?

Adding a sysctl was my very first query to Linux lists.  I thought
everything was covered in that and subsequent threads.

    Subject: query: adding a sysctl
    Date: Fri, 02 Oct 2009 00:00:05 -0400

