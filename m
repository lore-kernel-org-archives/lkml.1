Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYBFQgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYBFQgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYBFQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:36:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51372 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYBFQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:36:12 -0500
Date: Wed, 6 Feb 2008 17:36:11 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel support for newer UDF versions (> 2.01)
Message-ID: <20080206163611.GB23382@atrey.karlin.mff.cuni.cz>
References: <1201981141.3197.7.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201981141.3197.7.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> Does someone know if it's planned (or even in the works) to support
> newer versions of the UDF filesystem?
> Especially the versions 2.50 and 2.60 would be very interesting for
> mounting BluRay discs (and HD DVD)...
> 
> I've seen somewhere a patch but that was pretty old and AFAIK not yet
> finished or included in the vanilla tree.
  There UDF project at SF: http://sourceforge.net/projects/linux-udf/
I think there's a patch for 2.50 support which is quite recent (2.6.24).
I plan to merge the support when Sebastian submits it (I'm already in
contact with him regarding this).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
