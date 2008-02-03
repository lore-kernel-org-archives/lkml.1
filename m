Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbYBCTX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbYBCTX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 14:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYBCTXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 14:23:48 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33627 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbYBCTXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 14:23:47 -0500
Subject: Re: [patch] scsi: fix spurious build failures in aic7xxx
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Hannes Reinecke <hare@suse.de>,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20080203074143.GA19981@uranus.ravnborg.org>
References: <20080201225056.GA18302@elte.hu>
	 <20080202135935.GA23838@uranus.ravnborg.org>
	 <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu>
	 <20080202141857.GA8635@elte.hu>
	 <20080202162611.GA24765@uranus.ravnborg.org>
	 <20080202171020.GB12748@elte.hu> <20080203045441.GA12128@elte.hu>
	 <20080203074143.GA19981@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 13:23:42 -0600
Message-Id: <1202066623.3318.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-03 at 02:41 -0500, Sam Ravnborg wrote:
>         Thanks for testing Ingo.
>         
>         James - I plan to submit this via kbuild.git in about 10
>         hours.
>         Let me know if you would like it to go in via scsi and I
>         will drop you an updated patch (need to elaboarte a bit more
>         in
>         the commit message).

Sure, the changes look fine .. and will not conflict with anything
pending I currently have.  You can add my acked-by if you want.

Please also note the @steeleye.com email address doesn't come to me any
more, so this email had to be forwarded.

James


