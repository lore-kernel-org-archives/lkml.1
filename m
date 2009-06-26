Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZFZOZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZFZOZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZFZOZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:25:38 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52382 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbZFZOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:25:38 -0400
Subject: Re: [PATCH 00/15] drbd: a block device for HA clusters
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>
In-Reply-To: <200906261715.40545.a1426z@gawab.com>
References: <1246017715-9821-1-git-send-email-philipp.reisner@linbit.com>
	 <200906261715.40545.a1426z@gawab.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 09:25:35 -0500
Message-Id: <1246026335.3925.16.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 17:15 +0300, Al Boldi wrote:
> Philipp Reisner wrote:
> > Short Description
> >
> >   DRBD is a shared-nothing, synchronously replicated block device.
> 
> What do you mean by "shared-nothing"?

If you actually type "shared nothing" into google, the first hit will be
the wikipedia article describing this.

James


