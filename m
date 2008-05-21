Return-Path: <linux-kernel-owner+w=401wt.eu-S1764152AbYEUCRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764152AbYEUCRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbYEUCRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:17:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbYEUCRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:17:30 -0400
Date: Tue, 20 May 2008 19:17:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.14-rc3
Message-Id: <20080520191704.ea856364.akpm@linux-foundation.org>
In-Reply-To: <20080519112402.GF17439@nb.net.home>
References: <20080519112402.GF17439@nb.net.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 13:24:02 +0200 Karel Zak <kzak@redhat.com> wrote:

> The third util-linux-ng 2.14 release candidate is available at
> 
>    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.14/
> 
> 
> Feedback and bug reports, as always, are welcomed.

I think it would be useful to have a util-linux mention in the kernel's
./MAINTAINERS.  We're rather joined-at-the-hip and you guys are a bit
hard to find.  If agreeable, please send a patch.

Have you considered adding collectl to util-linux?  If so, what was the
outcome?

Thanks.

