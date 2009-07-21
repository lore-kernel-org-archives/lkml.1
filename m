Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZGUFvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZGUFvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZGUFvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:51:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271AbZGUFvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:51:13 -0400
Date: Mon, 20 Jul 2009 22:49:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>, linux-next@vger.kernel.org
Subject: Re: [PATCH 00/16] drbd: a block device for HA clusters
Message-Id: <20090720224940.36da1ef8.akpm@linux-foundation.org>
In-Reply-To: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  6 Jul 2009 17:39:19 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:

> As the first bit of the DBRD patch already got upstream (see commit
> 10fc89d01a) it is time to get more of DRBD towards mainline.
> 
> Here is a post of drbd-8.3.2 for inclusion into linux-mm (or linux-next).
> 
> Patch set attached. Git tree available:
> git pull git://git.drbd.org/linux-2.6-drbd.git drbd

I don't think I can be bothered reading all this again ;)  I trust that
earlier review comments were suitably addressed.

Please prepare a tree for inclusion in linux-next, send that off to
Stephen and unless someone can identify reasons otherwise, send Linus a pull
request for 2.6.32-rc1.

