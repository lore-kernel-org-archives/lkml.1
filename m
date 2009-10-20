Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbZJTC5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbZJTC5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 22:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZJTC5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 22:57:30 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:21444 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbZJTC5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 22:57:30 -0400
Date: Mon, 19 Oct 2009 20:57:33 -0600
From: Alex Chiang <achiang@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: shaohua.li@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] ACPI: dock: convert sysfs attributes to an
	attribute_group
Message-ID: <20091020025733.GA5814@ldl.fc.hp.com>
References: <20091019211132.5412.80438.stgit@bob.kio> <20091019211424.5412.15540.stgit@bob.kio> <20091020013844.GB24370@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020013844.GB24370@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Mon, Oct 19, 2009 at 03:14:24PM -0600, Alex Chiang wrote:
> > As suggested by Dmitry Torokhov, convert the individual sysfs
> > attributes into an attribute group.
> > 
> > This change eliminates quite a bit of copy/paste code in the
> > error handling paths.
> > 
> 
> Looks good to me, thank you for making the changes.

Thank you for your patience along the way.

Can I count this as an Acked-by? :)

/ac

