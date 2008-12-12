Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYLLJp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYLLJp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYLLJpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:45:21 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48781 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYLLJpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:45:20 -0500
Subject: Re: [PATCH 4/4] s390: remove s390_root_dev_*()
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Mark McLoughlin <markmc@redhat.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1229074546.4041.8.camel@blaa>
References: <1229012203.7968.79.camel@blaa>
	 <1229012216-4211-1-git-send-email-markmc@redhat.com>
	 <1229012216-4211-2-git-send-email-markmc@redhat.com>
	 <1229012216-4211-3-git-send-email-markmc@redhat.com>
	 <1229012216-4211-4-git-send-email-markmc@redhat.com>
	 <20081211180025.045b9b4a@gondolin>  <20081212102951.01446f22@gondolin>
	 <1229074546.4041.8.camel@blaa>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 12 Dec 2008 10:45:16 +0100
Message-Id: <1229075116.28887.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 09:35 +0000, Mark McLoughlin wrote:
> From: Mark McLoughlin <markmc@redhat.com>
> Subject: [PATCH] s390: remove s390_root_dev_*()
> 
> Replace s390_root_dev_register() with root_device_register() etc.
> 
> [Includes fix from Cornelia Huck]
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>

I can carry the patch in my patch queue. Thanks.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


