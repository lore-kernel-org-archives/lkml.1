Return-Path: <linux-kernel-owner+w=401wt.eu-S965744AbXEGQ3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744AbXEGQ3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965687AbXEGQ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:29:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:10621 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965589AbXEGQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mA9XZVP3nOwZejTQdedcmtKG3DEYm7l1rbENKUEb0dVrkArfT6ejgBcSMJe8iVy5NP/c90F1+mTEe7ULBnDAkxRPJwHd9LlyJEpBgvle97gxrgF4DOkSWxOCunHSJKSO9tFfVsg1vsoxgi0YwzC4yVMjgBtD1QDTdAlVqKpsiU8=
Message-ID: <a781481a0705070929q18525cbdp1e3b99705a7b18d4@mail.gmail.com>
Date: Mon, 7 May 2007 21:59:28 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: gmail is a bit too popular..
Cc: "Matti Aarnio" <matti.aarnio@zmailer.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070507145555.GG3883@mea-ext.zmailer.org>
	 <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, John Anthony Kazos Jr. <jakj@j-a-k-j.com> wrote:
> > In the  linux-kernel  -list subscribers domain popularity
> > analysis I got following results:
> >
> >    2101 gmail.com
> >      49 googlemail.com
> >      46 gmx.de
> >      41 redhat.com
> >      33 yahoo.com
> >      23 suse.de
> >      22 gmx.net
> >      21 comcast.net
> >
> >
> > The  gmail  is so popular, that with their somewhat rudimentary
> > inbound MTA software this kind of recipient masses take horrible
> > time to feed in...  Mere 0.5-0.7 seconds per recipient, but..
> [...]
> How about some elitism here? Dedicate a certain number of streams to
> everything-except-gmail, so MTAs from the 21st century can get their mail
> faster, and set the rest on gmail-only. Slows down gmail and speeds up the
> rest?

Aargh ... what did us poor folk do to deserve this? I understand ~2000
of those Gmail users are only spectators, but most others don't have a
choice. In my case, my university doesn't allow mailboxes to go beyond
a certain limit and only a couple of weeks worth of lkml would eat
that up. And I suspect other free web mail servers that offer 3 GB of
space too would be equally slower. But I do hope someone from Google
listened to this -- half a second per recipient ... *sucks*.
