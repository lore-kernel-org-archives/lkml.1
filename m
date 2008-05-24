Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbYEXS3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbYEXS3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbYEXS3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:29:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:48460 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627AbYEXS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=g8CFWqcTpM9vOd0FFLosj4F1+fI1tAv1CqL5zFnPIrIRnoBHnb9zHDc5jUC6hZA41FOz6SgfStPDCQlwWPR77RkQqog0WBgOEVLZ8nexlBHt8YTBzlAfx0daqqsY+VBslrlTxLGxfmZQM5roYGMSMxoF9iBiEOJ89k/ZCRZe6Yo=
Date: Sat, 24 May 2008 21:29:27 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
       flamingice@sourmilk.net
Subject: Re: regression iwl3945/mac80211: association times out since
	2.6.26-rc1
Message-ID: <20080524182852.GA9722@robinhood.home>
References: <20080520184859.GA8168@robinhood.home>
	<20080521054743.GA9910@robinhood.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521054743.GA9910@robinhood.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 08:47:44AM +0300, Michael S. Tsirkin wrote:
> FYI, I created an item in bugzilla to track this
> http://bugzilla.kernel.org/show_bug.cgi?id=10765

As requested, more configuration and log files have been attached
to this item.

