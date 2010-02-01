Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0BANB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:01:28 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47246 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0BANB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:01:27 -0500
Date: Mon, 1 Feb 2010 08:01:18 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: xtfeng@gmail.com, rjw@sisk.pl, htd@fancy-poultry.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
Message-ID: <20100201130118.GD25094@hmsreliant.think-freely.org>
References: <7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
 <20100131.232050.266652459.davem@davemloft.net>
 <20100201115518.GA25094@hmsreliant.think-freely.org>
 <20100201.044911.15611947.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201.044911.15611947.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 04:49:11AM -0800, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Mon, 1 Feb 2010 06:55:18 -0500
> 
> > He claims this dependency is deliberate and requires, to which I agree, but he
> > would seem to fix that by making the dccp_probe module error out in the event
> > that dccp wasn't loaded.  Why bother with that?
> 
> Neil, please get into the thread Gerrit started so he can see your
> questions and responses too.
> 
> I already chided him for not CC:'ing you in the first place, guys
> stop hiding from eachother :-)
> 
I already posted to both of his posts (about 45 minutes ago).  I think vger is
being slow (whoever runs that system should really tune it up ;) )

Neil

