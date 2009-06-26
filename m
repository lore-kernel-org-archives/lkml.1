Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZFZPuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZFZPuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZFZPt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:49:59 -0400
Received: from mailhost18.gawab.com ([66.220.20.18]:37027 "HELO
	info3.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750899AbZFZPt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:49:59 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/15] drbd: a block device for HA clusters
Date: Fri, 26 Jun 2009 18:43:59 +0300
User-Agent: KMail/1.5
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
References: <1246017715-9821-1-git-send-email-philipp.reisner@linbit.com> <200906261715.40545.a1426z@gawab.com> <1246026335.3925.16.camel@mulgrave.site>
In-Reply-To: <1246026335.3925.16.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906261843.59635.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2009-06-26 at 17:15 +0300, Al Boldi wrote:
> > Philipp Reisner wrote:
> > > Short Description
> > >
> > >   DRBD is a shared-nothing, synchronously replicated block device.
> >
> > What do you mean by "shared-nothing"?
>
> If you actually type "shared nothing" into google, the first hit will be
> the wikipedia article describing this.

Sure, but the point here is to choose a description that is clear and 
self-explanatory, and "shared-nothing" is neither clear nor self-explanatory.


Thanks!

--
Al

