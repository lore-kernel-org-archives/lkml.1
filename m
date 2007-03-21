Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbXCUSUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbXCUSUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbXCUSUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:20:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58369 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327AbXCUSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:20:38 -0400
Subject: Re: [PATCH] NOMMU: Supply get_unmapped_area() to fix NOMMU SYSV SHM
From: Adam Litke <agl@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070321174445.23664.91613.stgit@warthog.cambridge.redhat.com>
References: <20070321174445.23664.91613.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 13:20:35 -0500
Message-Id: <1174501235.21684.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 17:44 +0000, David Howells wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Supply a get_unmapped_area() to fix NOMMU SYSV SHM support.
> 
> Signed-Off-By: David Howells <dhowells@redhat.com>

Hmm, yes... So it would seem my fix for the shm stacked files stuff was
not quite complete.

Acked-by: Adam Litke <agl@us.ibm.com>
-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

