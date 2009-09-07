Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZIGKFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZIGKFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZIGKFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:05:14 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49921 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZIGKFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IxvQv+13DXcibtYyCTXelVx4oyp+G3FBdc/awC3xn84mc/W5O99iexXM7Iub575yFH
         UaGn9Xool3CF1lk0vJSDzSOOcNqCBzP7oi2k6LF8iHUHN4qs7zjoVipllbRBfxSLB2hE
         sWdpCC5kjro9dg0u5MttD3R/JCvuDKOgy5sNc=
Date: Mon, 7 Sep 2009 12:04:05 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [crmafra2@gmail.com: [Bisected] Output to external monitor is
	broken (Re: Linux 2.6.31-rc9)]
Message-ID: <20090907100405.GA4281@Pilar.aei.mpg.de>
References: <20090907021438.GA14608@zhen-devel.sh.intel.com> <1252292421.3609.71.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252292421.3609.71.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon  7.Sep'09 at 11:00:21 +0800, ykzhao wrote:
> On Mon, 2009-09-07 at 10:14 +0800, Zhenyu Wang wrote:
> Will you please add the boot option of "drm.debug=0x7" and attach the
> output of dmesg on the working/failing kernel?
> 
> It will be great if you boot the system with the KMS disabled and attach
> the Xorg.log.
> 
> Please attach the corresponding info in bug 14139.

It is there in the bugzilla now.
