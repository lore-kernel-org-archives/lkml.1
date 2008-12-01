Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYLAA3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYLAA3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYLAA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:29:43 -0500
Received: from mx2.netapp.com ([216.240.18.37]:55061 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbYLAA3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:29:42 -0500
X-IronPort-AV: E=Sophos;i="4.33,691,1220252400"; 
   d="scan'208";a="93038862"
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
 than 120 seconds"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1228090631.7112.11.camel@heimdal.trondhjem.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
	 <1228090631.7112.11.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Sun, 30 Nov 2008 19:29:40 -0500
Message-Id: <1228091380.7112.17.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 01 Dec 2008 00:29:41.0082 (UTC) FILETIME=[E6748BA0:01C9534B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-30 at 19:17 -0500, Trond Myklebust wrote:
> Can you see if the following 3 patches help? They're against 2.6.28-rc6,
> but afaics the problems are pretty much the same on 2.6.26.
> 
> Cheers
>   Trond

Sorry... I forgot to add that these 3 patches need to be applied to the
nfs server, not the client.

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
