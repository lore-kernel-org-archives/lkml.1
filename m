Return-Path: <linux-kernel-owner+w=401wt.eu-S933048AbXBLGy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbXBLGy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbXBLGy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:54:59 -0500
Received: from mga06.intel.com ([134.134.136.21]:10962 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933048AbXBLGy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:54:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,312,1167638400"; 
   d="scan'208"; a="195650697:sNHT20347887"
Date: Sun, 11 Feb 2007 22:55:04 -0800
From: Valerie Henson <val_henson@linux.intel.com>
To: Dave Jones <davej@redhat.com>, Michael Kerrisk <mtk-manpages@gmx.net>,
       val_henson@linux.interl.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
Message-ID: <20070212065503.GC20919@nifty>
References: <45CE0737.6010103@gmx.net> <20070211005400.GC6849@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211005400.GC6849@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 07:54:00PM -0500, Dave Jones wrote:
> 
> Whilst on the subject of RELATIME, is there any good reason why
> not to make this a default mount option ?

Ubuntu has been shipping with noatime as the default for some time
now, with no obvious problems (I'm running Ubuntu).  I see relatime as
an improvement on noatime.

-VAL
