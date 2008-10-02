Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYJBRCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYJBRCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 13:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYJBRCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:02:22 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:64370 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbYJBRCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iy57uBtTGigS+KhBheE8hvIVHCurbpFriihS2e/OeLwsZDcDmErNW6Z9IC5KpmeMOg
         r0cVKTqZoSKH+6nsTqknTh3Y+lurvnNQMaS5m9xhOUxeHFpW+PYJE6q9ot112SSf6lx7
         LraQ76zazWo3e5+wasJtaGHyiDZJibcwmL6go=
Date: Thu, 2 Oct 2008 21:02:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephen Clark <sclark46@earthlink.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Automatic config file generator
Message-ID: <20081002170210.GB7998@localhost>
References: <48E4FC91.5010300@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E4FC91.5010300@earthlink.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Stephen Clark - Thu, Oct 02, 2008 at 12:53:37PM -0400]
> Hello List,
>
> Is there a utility that will examine your system and generate a tailored 
> config file so I don't have to compile a zillion modules.
>
> Currently when I want to build the latest kernel I take the config file from
> my distro, (fedora), but it has every module in the world. So on my
> 1.8ghz core 2 duo laptop it takes about 30 min to build a new kernel.
>
> Thanks,
> Steve
> -- 
>
> "They that give up essential liberty to obtain temporary safety,
> deserve neither liberty nor safety."  (Ben Franklin)
>
> "The course of history shows that as a government grows, liberty
> decreases."  (Thomas Jefferson)
>
>

You could be interested by this thread

	http://lkml.org/lkml/2008/9/16/290

		- Cyrill -
