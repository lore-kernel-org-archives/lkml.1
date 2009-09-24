Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZIXWpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZIXWpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZIXWpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:45:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48654
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZIXWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:45:52 -0400
Date: Thu, 24 Sep 2009 15:46:10 -0700 (PDT)
Message-Id: <20090924.154610.142530742.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: jaswinder@kernel.org, Ricardo.Labiaga@netapp.com, bhalevy@panasas.com,
       andros@netapp.com, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix htmldocs sunrpc, clnt.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ABB9C17.3020307@oracle.com>
References: <1253794781.5860.29.camel@ht.satnam>
	<4ABB9C17.3020307@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 24 Sep 2009 09:19:35 -0700

> Jaswinder Singh Rajput wrote:
>>   DOCPROC Documentation/DocBook/networking.xml
>>   Warning(net/sunrpc/clnt.c:647): No description found for parameter 'req'
>>   Warning(net/sunrpc/clnt.c:647): No description found for parameter 'tk_ops'
>>   Warning(net/sunrpc/clnt.c:647): Excess function parameter 'ops' description in 'rpc_run_bc_task'
>> 
>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Ack.  Already sent, but possibly lost.

Applied.
