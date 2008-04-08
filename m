Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYDHLrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYDHLrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYDHLr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:47:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:47183 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYDHLr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Vwk6bH9jLub5l7Ps//WYiuJix1s5Zj3UE8ARDnvZDB78Ro1gnu2OJzH/wcRWvogvk4tSgTQoml1Ns4/7mZRtzSzxDW8ikNTHwTxIwnilEWgKzQwyza4IJ1WdlqRxgldN597JiHPjIO+QdYCEnCZVaeRzDZUthHo/RY2V+NEqtFM=
Date: Tue, 8 Apr 2008 13:46:43 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: keyboard disconnects with kernel 2.6.24-r4
Message-ID: <20080408114639.GA6554@joi>
References: <Pine.LNX.4.64.0804072357280.26562@twin.jikos.cz> <200804080510.m385A7DF016568@indigo.cs.bgu.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804080510.m385A7DF016568@indigo.cs.bgu.ac.il>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 08:10:07AM +0300, eial@cs.bgu.ac.il wrote:
> On Tue 08 Apr 0:58 2008 Jiri Kosina wrote:
> > On Mon, 7 Apr 2008, eial@cs.bgu.ac.il wrote:
> > 
> > > hello, I own a DV9000z, running gentoo and kernel 2.6.24-r3 on it, I'm 
> > > not using r4 because while working with the computer, after a while, my 
> > > keyboard disconnects. trying to shutdown the computer causes in system 
> > > freeze. this do not happens in r3, 
> > 
> > What are "r3" and "r4"? Do you mean -rc3 and -rc4? If so, please try to 
> > reproduce with recent kernel first (we are now past 2.6.25-rc8), and 
> > report back in case the problem still persists.
> r3 and r4 are rc3 and rc4, currently, the stable version is rc4, I try to stay with the current stable version inorder to reduce bugs
> cause I'm studying and dont have much free time on hand, can I disable this issue in rc4?

2.6.24-r3 and 2.6.24-r4 are NOT 2.6.24-rc3 and 2.6.24-rc4
2.6.24-r3 is 2.6.24.1 + some patches and
2.6.24-r4 is 2.6.24.4 + some patches

see:
http://dev.gentoo.org/~dsd/genpatches/
http://dev.gentoo.org/~dsd/genpatches/tarballs/

ps: please don't top post

