Return-Path: <linux-kernel-owner+w=401wt.eu-S935817AbXHOUVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935817AbXHOUVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbXHOUVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:21:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33028 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752602AbXHOUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:21:41 -0400
Date: Wed, 15 Aug 2007 13:21:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lucio Correia <ljhc@br.ibm.com>
cc: Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arndb@arndb.de>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
In-Reply-To: <1187207832.3002.4.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0708151321120.7326@schroedinger.engr.sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com> 
 <1187106239.3298.2.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0708141241450.30435@schroedinger.engr.sgi.com> 
 <dc1166600708141757q26c005d7o4c9c4d69e9d28460@mail.gmail.com> 
 <Pine.LNX.4.64.0708141910230.1409@schroedinger.engr.sgi.com>
 <1187207832.3002.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Lucio Correia wrote:

> It worked fine, both for normal kernel and for dump kernel on Cell. Is
> this patch intended to go mainline?

Yes it is now in my to-linus archive on git.kernel.org
