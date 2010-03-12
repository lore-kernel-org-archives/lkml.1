Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0CLEhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:37:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:49146 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab0CLEhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:37:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,624,1262592000"; 
   d="scan'208";a="253834645"
Date: Fri, 12 Mar 2010 12:37:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: VDR User <user.vdr@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Wei Ni <wni@nvidia.com>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel <alsa-devel@alsa-project.org>,
       Jaroslav Kysela <jkysela@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Pavel Hofman <pavel.hofman@insite.cz>
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Message-ID: <20100312043702.GA30428@localhost>
References: <20100308044614.GA29026@localhost> <a3ef07921003092142g23b93903v2b4af9c6b691bea0@mail.gmail.com> <alpine.LNX.2.00.1003100856420.4672@eeebox2.perex-int.cz> <a3ef07921003100005k6c7da149k99069cc13b3c8183@mail.gmail.com> <20100310125456.GA18509@localhost> <a3ef07921003100938o4d94161fw559bc9b563ce55b@mail.gmail.com> <alpine.LNX.2.00.1003110824390.4672@eeebox2.perex-int.cz> <a3ef07921003111015x2386cc80x73a2a4bd679b1fe1@mail.gmail.com> <alpine.LNX.2.00.1003111927570.4672@eeebox2.perex-int.cz> <a3ef07921003112032v3c3effb8n7e8f6599f4cbb453@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3ef07921003112032v3c3effb8n7e8f6599f4cbb453@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 12:32:51PM +0800, VDR User wrote:
> On Thu, Mar 11, 2010 at 10:32 AM, Jaroslav Kysela <perex@perex.cz> wrote:
> > All these parameters should be set: CONFIG_SND_PCM_XRUN_DEBUG,
> > CONFIG_SND_VERBOSE_PROCFS, CONFIG_SND_DEBUG . I updated wiki.
> 
> I have replied with both the result of my dmesg and syslog.  However,
> the mailing list seems to have rejected the message due to size (62k,
> but 60k is the limit).  Please let me know if you've received that
> post or if I have to repost and split dmesg + syslog into two.

Never mind, the CC'ed users should be able to receive it.

Thanks,
Fengguang

