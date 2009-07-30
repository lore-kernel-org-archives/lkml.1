Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZG3Rln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZG3Rln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZG3Rln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:41:43 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:48663 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZG3Rlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:41:42 -0400
Date: Thu, 30 Jul 2009 19:41:39 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ian Molton <ian@mnementh.co.uk>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou@mail.ru>, Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/2] power_supply: get_by_name and set_charged
	functionality
Message-ID: <20090730174139.GZ19257@buzzloop.caiaq.de>
References: <20090723183451.GI13236@buzzloop.caiaq.de> <1248374154-15606-1-git-send-email-daniel@caiaq.de> <20090728220635.GH19257@buzzloop.caiaq.de> <4A70249C.6060705@f2s.com> <20090729103659.GI19257@buzzloop.caiaq.de> <4A704451.1070004@mnementh.co.uk> <20090730141134.GB25759@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730141134.GB25759@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 06:11:34PM +0400, Anton Vorontsov wrote:
> Ian, Matt, much thanks for reviews and acks!
> Daniel, thanks for the patches, and for the patience. :-)
> 
> 
> Following patches applied to battery-2.6.git (for -next):
> 
> Daniel Mack (8):
>       ds2760_battery: delay power supply registration
>       ds2760_battery: export more features
>       ds2760_battery: add rated_capacity module parameter
>       ds2760_battery: handle full_active_uAh == 0 case correctly
>       ds2760_battery: add current_accum module parameter
>       power_supply: EXPORT_SYMBOL cleanups
>       power_supply: get_by_name and set_charged functionality
>       ds2760_battery: implement set_charged() feature
> 
> Let me know if I missed anything.

Looks good. Thanks a lot :) There might be some more coming up the next
days.

Daniel

