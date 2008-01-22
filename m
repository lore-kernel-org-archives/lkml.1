Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbYAVKBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbYAVKBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbYAVKB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:01:26 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36440 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYAVKB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:01:26 -0500
Message-ID: <4795BEF3.1090303@garzik.org>
Date: Tue, 22 Jan 2008 05:01:23 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: jacliburn@bellsouth.net
CC: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH 19/26] atl1: modernize down/up functions
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net> <1199152804-3889-20-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <1199152804-3889-20-git-send-email-jacliburn@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jacliburn@bellsouth.net wrote:
> From: Jay Cliburn <jacliburn@bellsouth.net>
> 
> Update atl1_down() and atl1_up() to conform with the current vendor driver
> version 1.2.40.2.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atlx/atl1.c |   21 ++++++++-------------
>  drivers/net/atlx/atl1.h |    1 -
>  drivers/net/atlx/atlx.c |    2 +-
>  3 files changed, 9 insertions(+), 15 deletions(-)

same comments continue...  these are software changes that need to be 
explained.

"conform with vendor driver" does not excuse failure to document changes 
in init and shutdown sequencing, for example.

