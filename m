Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbZLOQpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbZLOQpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760596AbZLOQpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:45:36 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36282 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760594AbZLOQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:45:34 -0500
Date: Tue, 15 Dec 2009 11:39:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <greg@kroah.com>, Reinette Chatre <reinette.chatre@intel.com>,
       Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>, stable@kernel.org,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
Message-ID: <20091215163923.GA8735@tuxdriver.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com> <1260848710-5650-1-git-send-email-ike.pan@canonical.com> <20091215041500.GB31200@kroah.com> <4B273479.6050502@canonical.com> <20091215134943.GA11667@kroah.com> <1260894840.4041.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260894840.4041.35.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 08:34:00AM -0800, Marcel Holtmann wrote:

> I agree here. Not copying Reinette on this is just wrong. And blindly
> picking some patches and sending them for -stable even more.

I agree that Reinette should have been copied.  I'm not sure I agree
that sending the patches was wrong by itself.

Canonical gets kicked in the teeth for lack of upstream participation
all the time.  I even have some of their enamel on my shoes...
But let's not be too hard on them for making a mistake while trying
to do something that is overall helpful to the community at large.

Just my $0.02...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
