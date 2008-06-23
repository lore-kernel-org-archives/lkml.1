Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYFWXUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYFWXUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYFWXTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:19:55 -0400
Received: from mx2.netapp.com ([216.240.18.37]:42354 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYFWXTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:19:54 -0400
X-IronPort-AV: E=Sophos;i="4.27,692,1204531200"; 
   d="scan'208";a="106827939"
Subject: Re: NFS oops in 2.6.26rc4
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Dave Jones <davej@redhat.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, chucklever@gmail.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080623231123.GB13679@redhat.com>
References: <20080527190419.GA14577@redhat.com>
	 <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com>
	 <20080530182126.GB32480@redhat.com> <1212172308.8579.20.camel@localhost>
	 <20080530190314.GC32480@redhat.com>
	 <CEA741EF-8E34-40FD-82A8-747AE1B6E78F@oracle.com>
	 <20080604141958.GA14148@redhat.com>
	 <E1135064-06EA-405C-A967-DFB1DC9F0418@oracle.com>
	 <20080604182015.GA20074@redhat.com> <1214235629.7205.19.camel@localhost>
	 <20080623231123.GB13679@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 23 Jun 2008 19:19:52 -0400
Message-Id: <1214263192.7205.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 23 Jun 2008 23:19:53.0008 (UTC) FILETIME=[A4132B00:01C8D587]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 19:11 -0400, Dave Jones wrote:
> On Mon, Jun 23, 2008 at 11:40:29AM -0400, Trond Myklebust wrote:
>  > Hi Dave,
>  > 
>  > Any chance you could give the attached patch a whirl to see if it fixes
>  > the NFS oops you reported?
> 
> Seems to have done the trick for me.  
> 
> 	Dave

Thanks Dave!

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
