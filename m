Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZBTU14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZBTU14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 15:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZBTU1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 15:27:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZBTU1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:27:44 -0500
Date: Fri, 20 Feb 2009 10:35:48 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
Message-ID: <20090220183548.GA4562@suse.de>
References: <fa686aa40902180748i2d621de1j1da7600e8cc3165f@mail.gmail.com> <ac3eb2510902180753l5dc94e5dje9154eaea9d2db29@mail.gmail.com> <fa686aa40902180834r2b9b8de0tcdc31c850f6323a6@mail.gmail.com> <ac3eb2510902180849o6d86bbfev337e1bc203d6543e@mail.gmail.com> <fa686aa40902180951q64c71581y3811062256685df7@mail.gmail.com> <ac3eb2510902181032h3f9ed994s212dd8b42ddca82@mail.gmail.com> <20090218183945.GA31797@suse.de> <fa686aa40902182250g1c4e7cb6o4d0102da35ab838b@mail.gmail.com> <ac3eb2510902191508w71cf7d76x4a8957ecee9c4e6@mail.gmail.com> <fa686aa40902200728k1466121cqb772bb9e5d1a777c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40902200728k1466121cqb772bb9e5d1a777c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 08:28:42AM -0700, Grant Likely wrote:
> Hi Kay,
> 
> Thanks for the reply, it clarifies a lot.  It sounds like this really
> should be documented (in Documentation/driver-model/device.txt?).  I'm
> happy to add a blurb to that effect and send a patch, but I want to
> make sure I really understand the model before I do so.

That would be wonderful to have, any documentation updates are gladly
accepted.

thanks,

greg k-h
