Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYIZHTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYIZHTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 03:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYIZHTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 03:19:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:49649 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYIZHTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 03:19:42 -0400
Date: Fri, 26 Sep 2008 09:19:40 +0200
From: Karsten Keil <kkeil@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: e1000e NVM corruption issue status
Message-ID: <20080926071940.GA19605@pingi.kke.suse.de>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.27-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 06:50:57PM -0700, Brandeburg, Jesse wrote:
> hardware affected:
> laptops and desktops with 82566 or 82567 based LAN parts, which are 
> machines with the ICH8 and ICH9 chipsets and a variety of processors.
> The machines I know of that have reported the issue include
> Lenovo X300
  We have  also a  R400 showing this issue
> HP 2510p
> Intel DP35JO
> Lenovo T61 (possibly)
> Lenovo X61 (possibly)

Lenovo X61 is verified (ethtool -e shows all FF)

-- 
Karsten Keil
SuSE Labs
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
