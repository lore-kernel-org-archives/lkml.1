Return-Path: <linux-kernel-owner+w=401wt.eu-S935475AbZDBJg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935475AbZDBJg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763875AbZDBJgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:36:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35661 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761566AbZDBJgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:36:43 -0400
Message-ID: <49D48726.6040106@garzik.org>
Date: Thu, 02 Apr 2009 05:36:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: IDE, packet commands and REQ_TYPE_SENSE?
References: <49D48600.2070109@garzik.org>
In-Reply-To: <49D48600.2070109@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Can we get rid of REQ_TYPE_SENSE?

Strike that, I forgot about blk_sense_request()

