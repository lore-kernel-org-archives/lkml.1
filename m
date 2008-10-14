Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYJNUwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYJNUwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYJNUvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:51:55 -0400
Received: from mx2.netapp.com ([216.240.18.37]:61441 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYJNUvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:51:54 -0400
X-IronPort-AV: E=Sophos;i="4.33,410,1220252400"; 
   d="scan'208";a="73349678"
Subject: Re: nfsd 2.6.28 merge plans
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1228.1224016436@redhat.com>
References: <20081014120753.7f968845.akpm@linux-foundation.org>
	 <20081008232237.GH14527@fieldses.org>  <1228.1224016436@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 14 Oct 2008 16:51:44 -0400
Message-Id: <1224017504.8907.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 14 Oct 2008 20:51:51.0601 (UTC) FILETIME=[AF05C210:01C92E3E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 21:33 +0100, David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Is anything happening with David Howells's fscache and cachefiles work over
> > there?
> 
> That's more NFS than NFSD.  I've tried emailing Trond a few times since
> KS/Plumbers, but I've had no response, so I'm not sure.
> 
> David

I'm happy with the changes that you made after the plumbers conf, so as
far as the NFS side of the patches is concerned, we should be close to
ready to merge.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
