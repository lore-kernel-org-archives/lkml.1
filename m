Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0CLEdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:33:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:36417 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab0CLEdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hSzPzi+9aI/iEcXTja3IsUtKf0lKDCTk1hiv15Cj3Ue+dF3Y0wYe1Yr3mJcrQuft/R
         a5ujiD7crYu+46c4Chy2ZDj05yqNNYmhbg6RCr3DELJMBLxrLYuIoPQhl5eNWL6bNzdD
         9k5XfeDZXRcOnbfhQl6JpEvq5W1HuTVJpZEBk=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1003111927570.4672@eeebox2.perex-int.cz>
References: <s5htyswpb18.wl%tiwai@suse.de> <20100308044614.GA29026@localhost>
	 <a3ef07921003092142g23b93903v2b4af9c6b691bea0@mail.gmail.com>
	 <alpine.LNX.2.00.1003100856420.4672@eeebox2.perex-int.cz>
	 <a3ef07921003100005k6c7da149k99069cc13b3c8183@mail.gmail.com>
	 <20100310125456.GA18509@localhost>
	 <a3ef07921003100938o4d94161fw559bc9b563ce55b@mail.gmail.com>
	 <alpine.LNX.2.00.1003110824390.4672@eeebox2.perex-int.cz>
	 <a3ef07921003111015x2386cc80x73a2a4bd679b1fe1@mail.gmail.com>
	 <alpine.LNX.2.00.1003111927570.4672@eeebox2.perex-int.cz>
Date: Thu, 11 Mar 2010 20:32:51 -0800
Message-ID: <a3ef07921003112032v3c3effb8n7e8f6599f4cbb453@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
From: VDR User <user.vdr@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Wei Ni <wni@nvidia.com>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel <alsa-devel@alsa-project.org>,
       Jaroslav Kysela <jkysela@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Pavel Hofman <pavel.hofman@insite.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 10:32 AM, Jaroslav Kysela <perex@perex.cz> wrote:
> All these parameters should be set: CONFIG_SND_PCM_XRUN_DEBUG,
> CONFIG_SND_VERBOSE_PROCFS, CONFIG_SND_DEBUG . I updated wiki.

I have replied with both the result of my dmesg and syslog.  However,
the mailing list seems to have rejected the message due to size (62k,
but 60k is the limit).  Please let me know if you've received that
post or if I have to repost and split dmesg + syslog into two.

Thanks,
Derek
