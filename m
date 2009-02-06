Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbZBFAJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbZBFAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZBFAJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:09:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:61913 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZBFAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:09:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SZgp3I99GxHWH+ox4YUVfykTT0NFfjfbkU/UoNH383y6reecHnGuX82h33KyW8rha1
         2I6O49ZKDOgvNyDTqI0Gf6TsRt6/2VdZ7lh61CJkq+O0Eh21PGdR6XvarnpehVKmHCZZ
         b9W8Jhcopehut7Dga7ibYB/0828Dg5RjBRthA=
Date: Fri, 6 Feb 2009 01:09:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/2] ring_buffer: remove unused flags parameter
Message-ID: <20090206000911.GE23999@nowhere>
References: <20090205181256.GH17653@ghostprotocols.net> <20090205221701.GA23999@nowhere> <20090206000455.GE16040@elte.hu> <20090206000630.GA23475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206000630.GA23475@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 01:06:30AM +0100, Ingo Molnar wrote:
> 
> > > codiff... I didn't know this great tool! :-)
> 
> Btw., you can find this tool in the 'dwarves' package on most distros.
> 
> 	Ingo

Exact, I just installed it.
Thanks.

