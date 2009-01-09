Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZAIVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZAIVc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbZAIVcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:32:46 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:63024 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbZAIVco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:32:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M3i9Z0UXsJw7lH9E/4kvTh50wWNtmXPdzcTYVxWJN7Xiihbtes+CpQl7pUZs9PQz+6
         6eVwJuALtTIpRDfzR4XymAV3oHQJQ78cttlZDVD4+D4fOgGALRC9wiUF4rrW2ZdHoh+U
         49u5GJ7bHEo87h7I8YKIyVbiANWjHl+vI5qxA=
Date: Sat, 10 Jan 2009 00:32:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org
Subject: Re: [RFC 0/4] net namespace for PPP
Message-ID: <20090109213241.GE11646@localhost>
References: <4967acca.0437560a.511e.0221@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967acca.0437560a.511e.0221@mx.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Fri, Jan 09, 2009 at 10:51:54PM +0300]
| Hi,
| 
| here is a series of RFC in attempt to implement
| net-namespaces for PPP protocol (including PPPoE
| and PPPoL2TP).
| 
| I would really appreciate _any_ kind of comments.
| Really doubt if there is no bugs in my implementation
| but it's RFC after all. Mostly -compile- tested so it
| requires strong review. One more time -- I would admire
| any kind of comments (even like -- it's completely broken
| and full of sh*t would be fine -- but with details please :).
| 
| 		Cyrill
| -- 
| 

Ah, forgot to mention the patches are over the
net-next-2.6 tree commit

commit 6332178d91ca1a9dbd99bd97cabbcf965d178e9f
Merge: 908a7a1... 739840d...
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Dec 23 17:56:23 2008 -0800

		- Cyrill -
