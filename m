Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXIZB2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXIZB2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXIZB2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:28:15 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50988 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbXIZB2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:28:14 -0400
Date: Wed, 26 Sep 2007 10:28:00 +0900
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: queued patches for SCSI for 2.6.24
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <1190768402.8707.20.camel@localhost.localdomain>
References: <1190768402.8707.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070925065233Q.tomof@acm.org>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 20:00:02 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> Andrew asked that I provide a status report of pending updates.  The
> list is attached below.  It's pretty much driver updates and minor bug
> fixes.  The main functionality changes are Kay's sysfs updates and the
> shift of the ULD attachement towards the block prep function.

Can we make new 'supporrted_mode' and 'active_mode' attributes look
better?

http://marc.info/?l=linux-scsi&m=118991196128245&w=2
