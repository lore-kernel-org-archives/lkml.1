Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0CCBwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:52:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:46243 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab0CCBwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:52:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,570,1262592000"; 
   d="scan'208";a="600747199"
Date: Tue, 2 Mar 2010 13:43:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Wei Ni <wni@nvidia.com>
Cc: "'Takashi Iwai'" <tiwai@suse.de>, "'akpm'" <akpm@linux-foundation.org>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'Pavel Hofman'" <pavel.hofman@insite.cz>
Subject: Re: [alsa-devel]  [PATCH]Support MCP89 and GT21x hdmi audio
Message-ID: <20100302054307.GA6165@localhost>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 07:27:53PM +0800, Wei Ni wrote:
> Hi, Takashi
> I developed the hdmi audio driver for new chipset MCP89 and GT21x.
> The new HAD controller and codec support standard HDMI operation.
> 
> I attached the patch file, please check it.

Wei Ni,

Can we avoid the big copy&paste and do more code reuse?
This benefits all of us in long term.

Thanks,
Fengguang
