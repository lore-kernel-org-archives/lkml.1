Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbZECFhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbZECFhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 01:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZECFh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 01:37:27 -0400
Received: from 1wt.eu ([62.212.114.60]:4225 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZECFh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 01:37:26 -0400
Date: Sun, 3 May 2009 07:36:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Message-ID: <20090503053557.GH570@1wt.eu>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <20090501015902.ed8b56d3.akpm@linux-foundation.org> <e2e108260905020033h457ed97ayfd8392d1249a943a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2e108260905020033h457ed97ayfd8392d1249a943a@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 09:33:35AM +0200, Bart Van Assche wrote:
> On Fri, May 1, 2009 at 10:59 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
> >
> >> This is a repost of DRBD
> >
> > Is it being used anywhere for anything?  If so, where and what?
> 
> One popular application is to run iSCSI and HA software on top of DRBD
> in order to build a highly available iSCSI storage target.

Confirmed, I have several customers who're doing exactly that.

Willy

