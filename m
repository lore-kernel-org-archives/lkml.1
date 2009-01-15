Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbZAOXM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbZAOXM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZAOXMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:12:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZAOXMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:12:18 -0500
Date: Thu, 15 Jan 2009 14:57:02 -0800
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Convert '/' to '!' in dev_set_name()
Message-ID: <20090115225702.GB18809@suse.de>
References: <adaljtjog90.fsf@cisco.com> <adad4evoeu9.fsf@cisco.com> <adafxjkfamh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adafxjkfamh.fsf@cisco.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 02:49:26PM -0800, Roland Dreier wrote:
> Greg, I still don't see this upstream; I think it should be merged
> expeditiously, since it makes some boxes panic on boot.  (One can
> generally recover by using dev=<major:minor> instead of dev=/dev/foo/bar
> but I still think having tester's boxes panic on boot because of a known
> fixed bug is not ideal)

Sorry, it's in my to-apply queue, it was behind these huge -stable
releases that i just got out today.

Should get to it tonight or tomorrow, don't worry, it's not forgotten.

thanks,

greg "my inbox is a mess" k-h
