Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZGUTAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZGUTAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZGUTAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:00:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43196 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZGUTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:00:30 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 15:00:30 EDT
Date: Tue, 21 Jul 2009 20:51:56 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Christoph Hellwig <hch@infradead.org>, Neil Brown <neilb@suse.de>,
       Nikanth Karthikesan <knikanth@suse.de>, Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Lars Marowsky-Bree <lmb@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [Drbd-dev] [PATCH 00/16] drbd: a block device for HA clusters
Message-ID: <20090721185156.GA10126@johann>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Bart Van Assche <bart.vanassche@gmail.com>,
	Kyle Moffett <kyle@moffetthome.net>,
	Christoph Hellwig <hch@infradead.org>, Neil Brown <neilb@suse.de>,
	Nikanth Karthikesan <knikanth@suse.de>, Greg KH <gregkh@suse.de>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Lars Marowsky-Bree <lmb@suse.de>,
	Jens Axboe <jens.axboe@oracle.com>, Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>, drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com> <20090720224940.36da1ef8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720224940.36da1ef8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 10:49:40PM -0700, Andrew Morton wrote:
> On Mon,  6 Jul 2009 17:39:19 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
> > Patch set attached. Git tree available:
> > git pull git://git.drbd.org/linux-2.6-drbd.git drbd
> 
> I don't think I can be bothered reading all this again ;)  I trust that
> earlier review comments were suitably addressed.

To the best of my knowledge, we addressed all of them, yes.

> Please prepare a tree for inclusion in linux-next,
> send that off to Stephen

Ok, will do.
Stephen: expect an explicit linux-next merge request
within the next few days.

> and unless someone can identify reasons otherwise,
> send Linus a pull request for 2.6.32-rc1.

Thanks very much,

	Lars
