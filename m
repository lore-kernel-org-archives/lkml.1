Return-Path: <linux-kernel-owner+w=401wt.eu-S1765482AbYBMEZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765482AbYBMEZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbYBMEZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:25:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbYBMEZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:25:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=pcVGeTtJaXWMxcEzMiyobNLQTAkc7Z7ZLZHweZkhEe3ivMZ69WAEPPoXE8cw/9f+0
	WYXEDu9A5EbHfEcIhHuVQ==
Date: Tue, 12 Feb 2008 20:23:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080212221354.a33799f2.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com> <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com> <20080212221354.a33799f2.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Paul Jackson wrote:

> > I've redone my patchset based on the feedback that I've received
> 
> Will you be sending that along soon?  I was just getting into my
> review of this patchset, and I suppose it would be better to
> review the latest and greatest.
> 

Lee had some questions and comments that I've recently addressed so I 
wanted to give him a chance to respond before sending it out again in case 
more changes need to be made.

I'll email the current set to you now.

		David
