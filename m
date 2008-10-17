Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbYJQIHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbYJQIHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYJQIHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:07:07 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:55692 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYJQIHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:07:02 -0400
Subject: Re: [GIT PULL] kernel message catalog patches
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
In-Reply-To: <1224168620.9617.14.camel@localhost>
References: <1224168620.9617.14.camel@localhost>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 17 Oct 2008 09:59:14 +0200
Message-Id: <1224230354.4631.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, 2008-10-16 at 16:50 +0200, Martin Schwidefsky wrote:
> please pull from 'kmsg' branch of
> 
>         git://git390.osdl.marist.edu/pub/scm/linux-2.6.git kmsg
> 
> to get the kernel message catalog code. This is been reworked half
> a dozen times and this is the outcome. The bulk of this patch set
> are the printk changes and documentation files for s390. The three
> patches are:
>   "[S390] kmsg: tagged kernel messages.",
>   "[S390] kmsg: tagged device messages." and
>   "[S390] kmsg: Kernel message catalog script."

I've fixed the merge conflicts with todays git and recreated the kmsg
branch on git390.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


