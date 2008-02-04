Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYBDPao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYBDPao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYBDPaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:30:23 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37468 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbYBDPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:30:21 -0500
Subject: Re: Integration of SCST in the mainstream Linux kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <47A7049A.9000105@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 09:30:15 -0600
Message-Id: <1202139015.3096.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 15:27 +0300, Vladislav Bolkhovitin wrote:
> Vladislav Bolkhovitin wrote:
> So, James, what is your opinion on the above? Or the overall SCSI target 
> project simplicity doesn't matter much for you and you think it's fine 
> to duplicate Linux page cache in the user space to keep the in-kernel 
> part of the project as small as possible?

The answers were pretty much contained here

http://marc.info/?l=linux-scsi&m=120164008302435

and here:

http://marc.info/?l=linux-scsi&m=120171067107293

Weren't they?

James


