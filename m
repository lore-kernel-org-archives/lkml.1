Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbZLOR2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbZLOR2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760667AbZLOR2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:28:06 -0500
Received: from adelie.canonical.com ([91.189.90.139]:32804 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662AbZLOR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:28:05 -0500
Message-ID: <4B27C71C.5060109@canonical.com>
Date: Tue, 15 Dec 2009 18:27:56 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>, stable@kernel.org,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com> <1260848710-5650-1-git-send-email-ike.pan@canonical.com> <20091215041500.GB31200@kroah.com> <4B273479.6050502@canonical.com> <20091215134943.GA11667@kroah.com> <1260894840.4041.35.camel@localhost.localdomain> <20091215163923.GA8735@tuxdriver.com> <20091215171433.GA4337@kroah.com>
In-Reply-To: <20091215171433.GA4337@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Dec 15, 2009 at 11:39:24AM -0500, John W. Linville wrote:
>> On Tue, Dec 15, 2009 at 08:34:00AM -0800, Marcel Holtmann wrote:
>>
>>> I agree here. Not copying Reinette on this is just wrong. And blindly
>>> picking some patches and sending them for -stable even more.
>> I agree that Reinette should have been copied.  I'm not sure I agree
>> that sending the patches was wrong by itself.
> 
> I'm not saying it is wrong, but I agree, you need to copy the
> maintainer, as we would need their ack before being able to accept any
> type of backport.
> 
> Ike, the script, scripts/get_maintainer.pl is your friend here.

I should take some of the bashing here for not having been too
specific when pushing people to "send it to stable". As John said,
we are learning here.

I see that this gets improved.

Thanks,
Stefan

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

