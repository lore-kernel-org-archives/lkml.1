Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZAGBDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZAGBDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbZAGBDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:03:06 -0500
Received: from mx2.netapp.com ([216.240.18.37]:59098 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758544AbZAGBDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:03:05 -0500
X-IronPort-AV: E=Sophos;i="4.37,222,1231142400"; 
   d="scan'208";a="108988288"
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <1231289847.14345.243.camel@localhost>
References: <ae2fa56f38f87da3a90ab6fe39954b2b.squirrel@webmail.uio.no>
	 <1231289847.14345.243.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 06 Jan 2009 20:02:33 -0500
Message-Id: <1231290153.11487.34.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 07 Jan 2009 01:03:03.0838 (UTC) FILETIME=[B1799BE0:01C97063]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 16:57 -0800, Matt Helsley wrote:
> On Tue, 2009-01-06 at 19:39 -0500, trond.myklebust@fys.uio.no wrote:
> > On Tue, 2009-01-06 at 16:08 -0800, Matt Helsley wrote:
> > > IMHO This seems more incorrect than trying to use a more proximal
> > namespace.
> > 
> > You have yet to explain why.
> 
> Yes, I know I have to explain why. If you would please have a little
> more patience you might see I have replied to your original request for
> an explanation -- I *just* sent it out. If I don't see it show up soon
> I'll resend it as a reply here. OK?

Sorry if you saw the request twice. My mail server at uio.no appears to
be on the blink, so I switched to the netapp account...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
