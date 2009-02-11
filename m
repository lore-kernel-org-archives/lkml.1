Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZBKH1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZBKH1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZBKH1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:27:12 -0500
Received: from 60-242-66-41.static.tpgi.com.au ([60.242.66.41]:50924 "EHLO
	sibyl.beware.dropbear.id.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbZBKH1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:27:11 -0500
X-Greylist: delayed 2726 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 02:27:10 EST
DomainKey-Signature: a=rsa-sha1; s=dk1; d=beware.dropbear.id.au; c=simple; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:date:
	message-id:mime-version:x-mailer:
	content-transfer-encoding:x-greylist;
	b=k/oSKpwyCmJW6ZbGEqvyJwNsIxLyKqEOxZ8GH2SxMYZlXJze8uldaoz7L98BOD+Pi
	9WGkDzu5xFQ30tCouBjiw==
Subject: Re: [1/1] w1: w1 temp calculation overflow fix.
From: Ian Dall <ian@beware.dropbear.id.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zbr@ioremap.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090209153125.04210608.akpm@linux-foundation.org>
References: <20090209214217.GA14958@ioremap.net>
	 <20090209135641.0367a71f.akpm@linux-foundation.org>
	 <20090209220830.GA15633@ioremap.net>
	 <20090209144803.821aa33e.akpm@linux-foundation.org>
	 <20090209153125.04210608.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 17:11:12 +1030
Message-Id: <1234334472.13862.208.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (sibyl.beware.dropbear.id.au [10.0.0.2]); Wed, 11 Feb 2009 17:11:16 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 15:31 -0800, Andrew Morton wrote:
> On Mon, 9 Feb 2009 14:48:03 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > But we still don't have a _reason_.  Presumably the bug causes the
> > driver to malfunction in some manner.
> 
> ah-hah.  I discovered http://bugzilla.kernel.org/show_bug.cgi?id=12646
> 
> Now all is revealed!

I've been out of the loop a couple of days. Is there anything else
needed from me?

Regards,
Ian


-- 
Ian Dall <ian@beware.dropbear.id.au>

