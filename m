Return-Path: <linux-kernel-owner+w=401wt.eu-S1765930AbXHAPzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765930AbXHAPzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbXHAPyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:54:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32943 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbXHAPyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:54:49 -0400
Date: Wed, 1 Aug 2007 16:54:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 010 of 35] New function blk_req_append_bio
Message-ID: <20070801155448.GA19216@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org
References: <20070731112539.22428.patches@notabene> <1070731021640.25225@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070731021640.25225@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 12:16:40PM +1000, NeilBrown wrote:
>  /*
> - * Temporary export, until SCSI gets fixed up.
> + * Temporary(?) export, until SCSI gets fixed up.
>   */

This abuse is still scheduled to go away, even if it didn't happen as
part of the bsg introduction as I had hoped.

