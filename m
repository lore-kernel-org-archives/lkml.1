Return-Path: <linux-kernel-owner+w=401wt.eu-S1764866AbYBOItX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764866AbYBOItX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYBOItN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:49:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYBOItM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:49:12 -0500
Message-ID: <47B55202.2090304@redhat.com>
Date: Fri, 15 Feb 2008 08:49:06 +0000
From: Nick Clifton <nickc@redhat.com>
Organization: Registered Address: Red Hat UK Ltd, Amberley Place, 107-111
 Peascod Street, Windsor, Berkshire, SI4 1TE, United Kingdom.,Registered in
 England and Wales under Company Registration No. 3798903. Directors: Michael
 Cunningham (USA), Charlie Peters (USA) and David Owens (Ireland)
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: David Howells <dhowells@redhat.com>, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-am33-list] Re: Compiler for mn10300?
References: <20080213195951.GA27391@cs181133002.pp.htv.fi>	<11844.1202944399@redhat.com> <20080214201237.GA23227@cs181133002.pp.htv.fi>
In-Reply-To: <20080214201237.GA23227@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

> What are the plans regarding getting a plain upstream gcc compiling the 
> kernel?

One of the things on my plate is to get the -mno-mem-funcs patch 
contributed upstream.  (Along with a lot of other pending AM33 patches, 
such as the support for the AM34 processor).  As it happens MEI have 
just opened an issue with regard to -mno-mem-funcs, so any pushing of 
the patch will have to wait until that is resolved.

Cheers
   Nick


