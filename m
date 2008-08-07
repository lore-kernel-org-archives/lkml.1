Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYHGMit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYHGMit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYHGMii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:38:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYHGMig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:38:36 -0400
Subject: Re: Btrfs v0.16 released
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1217962876.15342.33.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 11:14:24 +0200
Message-Id: <1218100464.8625.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 15:01 -0400, Chris Mason wrote:

> There are still more disk format changes planned, but we're making every
> effort to get them out of the way as quickly as we can.  You can see the
> major features we have planned on the development timeline:
> 
> http://btrfs.wiki.kernel.org/index.php/Development_timeline

Just took a peek, seems to be slightly out of date as it still lists the
single mutex thingy.

Also, how true is the IO-error and disk-full claim?

