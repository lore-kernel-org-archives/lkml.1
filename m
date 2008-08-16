Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYHPAOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYHPAOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 20:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYHPANw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 20:13:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbYHPANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 20:13:51 -0400
Date: Fri, 15 Aug 2008 17:13:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI
 9835
Message-Id: <20080815171349.fbebd261.akpm@linux-foundation.org>
In-Reply-To: <3f9a31f40808050800h7073b82al1342f7e23cf1e1b3@mail.gmail.com>
References: <3f9a31f40808050800h7073b82al1342f7e23cf1e1b3@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 20:30:10 +0530
"Jaswinder Singh" <jaswinderlinux@gmail.com> wrote:

> /dev/ttyS1 and /dev/ttyS2 of NetMos Technology PCI 9835 is giving Junk
> characters in minicom but /dev/tyS0 is working perfectly.

Is this still the case in 2.6.27-rc3?

Was the same bug present in 2.6.26?  2.6.25?

Thanks.
