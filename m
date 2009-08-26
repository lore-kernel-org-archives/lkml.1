Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbZHZTcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbZHZTcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZHZTcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:32:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZHZTcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:32:02 -0400
Date: Wed, 26 Aug 2009 20:32:02 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: dm snapshot: implement .iterate_devices
Message-ID: <20090826193202.GI643@agk-dp.fab.redhat.com>
Mail-Followup-To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <1251007867-13004-1-git-send-email-snitzer@redhat.com> <20090826145045.GH643@agk-dp.fab.redhat.com> <20090826181908.GB26018@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826181908.GB26018@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 02:19:08PM -0400, Mike Snitzer wrote:
> I'll work on a proper solution for snapshot_iterate_devices() and get
> that to you ASAP.
 
So let's push this patch as-is for 2.6.31 as it clearly fixes one problem,
and determine the right way of handling the characteristics of the 'cow'
device in a supplementary patch.

Alasdair

