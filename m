Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYIEI0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYIEI0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYIEIZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:25:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbYIEIZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:25:47 -0400
Date: Fri, 5 Sep 2008 01:25:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5-mm1
Message-Id: <20080905012516.fd25685b.akpm@linux-foundation.org>
In-Reply-To: <a4423d670809050050r148df4e8md85774714b1e46ee@mail.gmail.com>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
	<a4423d670809050050r148df4e8md85774714b1e46ee@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 11:50:06 +0400 "Alexander Beregalov" <a.beregalov@gmail.com> wrote:

> 2008/9/5 Andrew Morton <akpm@linux-foundation.org>:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.27-rc5/2.6.27-rc5-mm1/
> Hi Andrew
> 
> 2.6.27-rc5-mm1.gz seems broken
> gzip: 2.6.27-rc5-mm1.gz: unexpected end of file
> The result does not contain drivers/net/wireless/libertas_tf/
> 
> gpg sign seems good

oops, thanks, my net connection fell over at a bad time and I didn't
repair all the damage.

I just uploaded the 5160786-byte 2.6.27-rc5-mm1.gz - it should be their
in a few minutes.

