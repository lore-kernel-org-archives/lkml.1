Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbYHFI14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbYHFI14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbYHFIZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:25:52 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:21596 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbYHFIZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:25:51 -0400
Subject: Re: [PATCH] docbook: fix s390 fatal error after header files moved
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <20080805145929.0443f8bf.randy.dunlap@oracle.com>
References: <20080805145929.0443f8bf.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 06 Aug 2008 10:24:57 +0200
Message-Id: <1218011097.20769.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 14:59 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Fix (fatal error) s390 docbook file to handle renamed header files.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/DocBook/s390-drivers.tmpl |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Oops.. thanks Randy.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


