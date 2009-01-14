Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbZANKV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbZANKV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761068AbZANKVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:21:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58597
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760827AbZANKVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:21:40 -0500
Date: Wed, 14 Jan 2009 02:21:40 -0800 (PST)
Message-Id: <20090114.022140.169499153.davem@davemloft.net>
To: Jesper.Nilsson@axis.com
Cc: roucaries.bastien@gmail.com, linux-kernel@vger.kernel.org, tj@kernel.org,
       gregkh@suse.de, stern@rowland.harvard.edu, jens.axboe@oracle.com,
       hinko.kocevar@cetrtapot.si
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090114101908.GF19262@axis.com>
References: <195c7a900901131511l7077eebar8396267e3f2b670b@mail.gmail.com>
	<20090114101908.GF19262@axis.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Nilsson <Jesper.Nilsson@axis.com>
Date: Wed, 14 Jan 2009 11:19:08 +0100

> The following patch works for CRIS, and is less intrusive than
> my earlier patch. If this the way to go I can resubmit a proper patch.

Out of curiosity, is there a way to get gcc to output code such
that data objects are aligned more naturally?  Some option or
similar?

