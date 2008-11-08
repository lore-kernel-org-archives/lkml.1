Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYKHSkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYKHSkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYKHSjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:39:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:51244 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYKHSjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:39:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CcMUJO7w2vH1VZN88yiZfBXH8o4eoDggOBFSWxg1H9pUkwLPO3/WI1KVdZ2OYlRHmE
         D2tpPTO6lklhp9qBeXZCQxuH3YYXiPmi+Cnp4PyZGRrKYmVp6vWKwrHowxvsHSlxyzWz
         RIy1UfzMWdH9cSUywvZm+vADQuHntWnpklUWo=
Date: Sat, 8 Nov 2008 21:43:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for November 7
Message-ID: <20081108184315.GA9382@x200.localdomain>
References: <20081107205457.f64dea59.sfr@canb.auug.org.au> <200811081257.45184.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811081257.45184.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 12:57:44PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Friday 07 November 2008, Stephen Rothwell wrote:
> > Changes since 20081106:
> 
> The following patch fixes the panic on loopback device registration
> (patch is an interdiff between old and new version of "net: Guaranetee
> the proper ordering of the loopback device." fix from Eric).
> 
> [ I'm sure this will get fixed in -net tree (if not fixed already)
>   but at the moment it is needed for linux-next. ]

This patch alone is a) not enough, and b) davem already pushed out correct
version.
