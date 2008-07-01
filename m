Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbYGAX2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbYGAX2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYGAX1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:27:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbYGAX1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:27:48 -0400
Date: Tue, 1 Jul 2008 16:27:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Peterson <joe@skyrush.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
Message-Id: <20080701162714.dfdbd7c1.akpm@linux-foundation.org>
In-Reply-To: <486476A5.7040801@skyrush.com>
References: <4861D685.4070308@skyrush.com>
	<87od5pqh4o.fsf@basil.nowhere.org>
	<4862DB28.3050001@skyrush.com>
	<48630286.2050006@skyrush.com>
	<87wskck5wi.fsf@devron.myhome.or.jp>
	<48639863.808@skyrush.com>
	<877iccxnwi.fsf@devron.myhome.or.jp>
	<4863B9AF.4080105@skyrush.com>
	<87zlp8w4br.fsf@devron.myhome.or.jp>
	<4863D037.90504@skyrush.com>
	<486476A5.7040801@skyrush.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 23:12:05 -0600
Joe Peterson <joe@skyrush.com> wrote:

> New mount option ("tz=UTC") for FAT (vfat/msdos) filesystems allowing
> timestamps to be in coordinated universal time (UTC) rather than
> local time in applications where doing this is advantageous (like
> digital cameras, etc.)

Can we update Documentation/filesystems/vfat.txt please?
