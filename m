Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbZLORPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbZLORPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932628AbZLORPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:15:47 -0500
Received: from kroah.org ([198.145.64.141]:41849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614AbZLORPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:15:45 -0500
Date: Tue, 15 Dec 2009 09:14:33 -0800
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>, stable@kernel.org,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
Message-ID: <20091215171433.GA4337@kroah.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
 <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
 <20091215041500.GB31200@kroah.com>
 <4B273479.6050502@canonical.com>
 <20091215134943.GA11667@kroah.com>
 <1260894840.4041.35.camel@localhost.localdomain>
 <20091215163923.GA8735@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215163923.GA8735@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:39:24AM -0500, John W. Linville wrote:
> On Tue, Dec 15, 2009 at 08:34:00AM -0800, Marcel Holtmann wrote:
> 
> > I agree here. Not copying Reinette on this is just wrong. And blindly
> > picking some patches and sending them for -stable even more.
> 
> I agree that Reinette should have been copied.  I'm not sure I agree
> that sending the patches was wrong by itself.

I'm not saying it is wrong, but I agree, you need to copy the
maintainer, as we would need their ack before being able to accept any
type of backport.

Ike, the script, scripts/get_maintainer.pl is your friend here.

thanks,

greg k-h
