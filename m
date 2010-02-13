Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0BMIx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:53:56 -0500
Received: from bamako.nerim.net ([62.4.17.28]:62847 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0BMIxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:53:55 -0500
Date: Sat, 13 Feb 2010 09:53:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>, mirrors@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100213095352.361702d0@hyperion.delvare>
In-Reply-To: <4B765F5D.9070106@zytor.com>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<4B75A5FE.8020408@zytor.com>
	<12c511ca1002122342x6a85459aic31f5c7e8f3786c1@mail.gmail.com>
	<4B765F5D.9070106@zytor.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010 00:14:21 -0800, H. Peter Anvin wrote:
> On 02/12/2010 11:42 PM, Tony Luck wrote:
> > 
> > 3) Keep all the .gz and .bz2 in the old 2.x hierarchy
> > 4) Only have .xz in the new 3.x directories.
> > 
> 
> I really dislike this for reasons already stated.  Keep in mind that the
> compression management is global to the entire archive, not just to the
> kernel, too.

How hard a requirement is this? It might be the right time to
reconsider... Tony's plan may not be perfect but overall I think I like
it.

-- 
Jean Delvare
