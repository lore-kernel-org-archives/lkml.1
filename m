Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbXA3Wea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbXA3Wea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbXA3We3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:34:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51153 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXA3We3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:34:29 -0500
Message-ID: <45BFC7F2.7090209@garzik.org>
Date: Tue, 30 Jan 2007 17:34:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>	<20070130195445.GE22022@kroah.com> <adazm80p4qp.fsf@cisco.com>
In-Reply-To: <adazm80p4qp.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> I disagree -- Linux today gets drivers not just from volunteers
> writing drivers from specs, but also from vendors writing drivers and
> volunteers writing drivers via reverse engineering.  And many of those
> drivers don't work on every platform and aren't supported by
> enterprise distros.  And when the community loses interest, drivers
> are left to bitrot.


Which of these actively maintained and supported drivers work on only 
one platform[1], and are excluded from enterprise distros?  Can we truly 
count them as "many", as you repeatedly claim?

	Jeff



[1] obviously excluding drivers for hardware where its only possible to 
occur on one platform, like SoC devices

