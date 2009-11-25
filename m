Return-Path: <linux-kernel-owner+w=401wt.eu-S934986AbZKYURj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986AbZKYURj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932338AbZKYURi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:17:38 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:36724 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbZKYURh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:17:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PAMWhKtIIDtOQneRoMHNdcHXM+WyDPu0fE3sPIEJkkGGbvY1n9n2neixVNH0aPrOW0
         mw4cewLka1CgEkcNx5U7L0nrJZ8dTwaLwexNG2b5Ecfla8ZmOfEG3Oxo/NxF5QzZQwwW
         LYkgv2ZU/QAJLqInX6PHMV4UqtOahFPqQlA1E=
Date: Wed, 25 Nov 2009 12:17:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anisse Astier <anisse@astier.eu>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - add Dell Vostro 1520 and 1720 to the
	reset list
Message-ID: <20091125201737.GB20732@core.coreip.homeip.net>
References: <20091124151250.03e185d1@destiny.ordissimo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124151250.03e185d1@destiny.ordissimo>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anisse,

On Tue, Nov 24, 2009 at 03:12:50PM +0100, Anisse Astier wrote:
> These laptops may have i8042 in a bad state at very first boot or if you plug
> in a non-Dell power supply.
> Thus this patch is needed for proper keyboard and touchpad function.
> 

Could youplease explain in more detail what the "bad state" is. And what
exactly do you mean by "first boot"? Cold boot? The very first boot
after assembling? Something else?

Thanks.

-- 
Dmitry
