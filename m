Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0CKUFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:05:25 -0500
Received: from xenotime.net ([72.52.64.118]:33324 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755901Ab0CKUFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:05:23 -0500
Message-ID: <4B994CFF.8090100@xenotime.net>
Date: Thu, 11 Mar 2010 12:05:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, sgruszka@redhat.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Document Linux's circular buffering capabilities [ver
 #2a]
References: <20100311192619.10462.53994.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100311192619.10462.53994.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/10 11:26, David Howells wrote:
> Document the circular buffering capabilities available in Linux.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Randy Dunlap <rdunlap@xenotime.net>

> ---
> 
>  Documentation/circular-buffers.txt |  231 ++++++++++++++++++++++++++++++++++++
>  Documentation/memory-barriers.txt  |   20 +++
>  include/linux/circ_buf.h           |    4 +
>  3 files changed, 255 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/circular-buffers.txt


-- 
~Randy
