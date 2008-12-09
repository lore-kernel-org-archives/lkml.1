Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYLIXFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYLIXFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYLIXFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:05:35 -0500
Received: from outbound-mail-125.bluehost.com ([67.222.38.25]:49833 "HELO
	outbound-mail-125.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755901AbYLIXFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:05:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=oBUcJKjJLGp0sE8vkYLx4h2yvJJ3Ir6voglO71aaESrv2494OyviHvQmm+OsaJOk/YMwf5H/TWfWpSeTddiyzxTjJf+E2wuPa2pOEDGkzjtNyyqlzXHYqW8RfPvawYMJ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] PCIe ASPM causes machine (HP Compaq 6735s) to sometimes freeze hard at boot at PCI initialization time
Date: Tue, 9 Dec 2008 15:05:10 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Shaohua Li <shaohua.li@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rafael Wysocki <rwysocki@suse.de>,
       "shemminger@linux-foundation.org" <shemminger@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Stable@kernel.org" <Stable@kernel.org>
References: <200811281328.55259.trenn@suse.de> <1228785579.9482.2.camel@sli10-desk.sh.intel.com> <200812091305.10824.trenn@suse.de>
In-Reply-To: <200812091305.10824.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091505.11313.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 09, 2008 4:05 am Thomas Renninger wrote:
> Hi Jesse,
>
> can you add this one, please.
> I adjusted the patch to suggestions from Matthew and Shaohua, thus
> added their Signed-offs.
>
> This should still go into .28 as it makes machines boot which
> now freeze since the ASPM patch was introduced.

Ok, just pushed it.  Thanks.

Jesse
