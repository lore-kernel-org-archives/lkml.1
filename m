Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbXGQIgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbXGQIgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXGQIgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:36:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbXGQIgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:36:43 -0400
Date: Tue, 17 Jul 2007 01:36:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lindsay Roberts" <lindsay.roberts.os@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, celinux-dev@tree.celinuxforum.org
Subject: Re: [PATCH] fs: Add romfs version 2
Message-Id: <20070717013635.d6d0b124.akpm@linux-foundation.org>
In-Reply-To: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 16:01:48 +1000 "Lindsay Roberts" <lindsay.roberts.os@gmail.com> wrote:

> * Increases romfs partition size limit from 2GB to 4GB.
> * Adds new derivative of romfs filesystem (rom2fs) with
>   block aligned regular file data to bring performance
>   parity with ext2/3. This is about 225% of the read
>   speed of the existing romfs.

Thanks.  I believe that the people on celinux-dev can help us to
evaluate this work.
