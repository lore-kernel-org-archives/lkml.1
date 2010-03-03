Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0CCDdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 22:33:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18066 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0CCDdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 22:33:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Tue, 02 Mar 2010 19:33:29 -0800
From: Wei Ni <wni@nvidia.com>
To: "'Wu Fengguang'" <fengguang.wu@intel.com>
CC: "'Takashi Iwai'" <tiwai@suse.de>, "'akpm'" <akpm@linux-foundation.org>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'Pavel Hofman'" <pavel.hofman@insite.cz>
Date: Wed, 3 Mar 2010 11:33:25 +0800
Subject: RE: [alsa-devel]  [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Topic: [alsa-devel]  [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Index: Acq6enP43xh2l0EeRWiwqbctPMhAbAAB2/dQ
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C16A89A119@HKMAIL01.nvidia.com>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com>
 <20100302054307.GA6165@localhost>
In-Reply-To: <20100302054307.GA6165@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Because there have no common codes for standard HDMI operation,
So in my patch file, there have some codes same as patch_intelhdmi.c
I think we could merge them later.

Thanks
Wei.

-----Original Message-----
From: Wu Fengguang [mailto:fengguang.wu@intel.com] 
Sent: Tuesday, March 02, 2010 1:43 PM
To: Wei Ni
Cc: 'Takashi Iwai'; 'akpm'; 'alsa-devel'; 'linux-kernel'; 'Pavel Hofman'
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio

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
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
