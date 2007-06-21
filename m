Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbXFURX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbXFURX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbXFURXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:23:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33126 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbXFURXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:23:46 -0400
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
	through other means
From: Ram Pai <linuxram@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-Reply-To: <467AA76F.9090107@zytor.com>
References: <467994BD.6000403@zytor.com>
	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com>
	 <1182442837.3342.13.camel@ram.us.ibm.com>  <467AA76F.9090107@zytor.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 10:20:55 -0700
Message-Id: <1182446456.3342.18.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 09:29 -0700, H. Peter Anvin wrote:
> Ram Pai wrote:
> > 
> > Peter, I am not working on it currently. But i am interested in getting
> > it done. I have the seed set of patches which had Al Viro's ideas
> > incorporated. Infact those patches were sent on lkml 2 months back.
> > Shall we start with those patches?
> > 
> 
> Are these the "unprivileged mount syscall" patches?

no. but those patches were sent in the same thread. Karel had provided
suggestions which I am yet to incorporate.

Give me today. I will send out the patches incorporating the comment
later in the evening.

ok?
RP

> 
> Otherwise I don't see any patches in my personal LKML cache (apparently
> my subscription to fsdevel was dropped at some point, so I don't have a
> stash of it.)


> 
> 	-hpa

