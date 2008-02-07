Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYBGJps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYBGJps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYBGJpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:45:40 -0500
Received: from styx.suse.cz ([82.119.242.94]:43554 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752733AbYBGJpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:45:39 -0500
Date: Thu, 7 Feb 2008 10:45:38 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel support for newer UDF versions (> 2.01)
Message-ID: <20080207094538.GA6140@duck.suse.cz>
References: <1201981141.3197.7.camel@fermat.scientia.net> <20080206163611.GB23382@atrey.karlin.mff.cuni.cz> <1202327121.3236.17.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202327121.3236.17.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 06-02-08 20:45:21, Christoph Anton Mitterer wrote:
> Hi.
> 
> On Wed, 2008-02-06 at 17:36 +0100, Jan Kara wrote:
> > I think there's a patch for 2.50 support which is quite recent (2.6.24).
> > I plan to merge the support when Sebastian submits it (I'm already in
> > contact with him regarding this).
> Ah great, so 2.6.25 probably?!
  Not very likely for 2.6.25 (I still don't have a patch with Sebastians's
Sign-off without which I cannot merge it and 2.6.25 merge window is closing
soon...). But hopefully it'll make it into 2.6.26.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
