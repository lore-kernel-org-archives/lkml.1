Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbYFWQDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbYFWQDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbYFWQDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:03:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbYFWQDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:03:21 -0400
Date: Mon, 23 Jun 2008 11:55:40 -0400
From: Dave Jones <davej@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, chucklever@gmail.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NFS oops in 2.6.26rc4
Message-ID: <20080623155540.GA10861@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>, chucklever@gmail.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080527190419.GA14577@redhat.com> <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com> <20080530182126.GB32480@redhat.com> <1212172308.8579.20.camel@localhost> <20080530190314.GC32480@redhat.com> <CEA741EF-8E34-40FD-82A8-747AE1B6E78F@oracle.com> <20080604141958.GA14148@redhat.com> <E1135064-06EA-405C-A967-DFB1DC9F0418@oracle.com> <20080604182015.GA20074@redhat.com> <1214235629.7205.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214235629.7205.19.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 11:40:29AM -0400, Trond Myklebust wrote:
 > Hi Dave,
 > 
 > Any chance you could give the attached patch a whirl to see if it fixes
 > the NFS oops you reported?

Yeah, I'll give it a shot, won't be until the end of the day/tomorrow though.

	Dave

-- 
http://www.codemonkey.org.uk
