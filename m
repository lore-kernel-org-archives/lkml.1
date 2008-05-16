Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbYEPPWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbYEPPWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbYEPPWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:22:25 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:50603 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194AbYEPPWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:22:24 -0400
Message-ID: <482DA724.5030007@keyaccess.nl>
Date: Fri, 16 May 2008 17:24:20 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Takashi Iwai <tiwai@suse.de>, Stas Sergeev <stsp@aknet.ru>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Non-working snd-pcsp
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it> <48275D8D.10500@aknet.ru> <4827F0A1.9090600@infracom.it> <48288ACC.1020909@aknet.ru> <48299F08.2060702@infracom.it> <4829B6A1.90707@infracom.it> <s5h7idycfmf.wl%tiwai@suse.de> <482A7A17.8070706@infracom.it> <s5hwslxb3t8.wl%tiwai@suse.de> <482C9A3E.3000009@infracom.it> <482C9F3E.4050104@aknet.ru> <alpine.LNX.1.10.0805161514190.15590@fbirervta.pbzchgretzou.qr> <s5hmymqe5a1.wl%tiwai@suse.de> <alpine.LNX.1.10.0805161715470.15590@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805161715470.15590@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-05-08 17:18, Jan Engelhardt wrote:

> Now, if pcspkr is deactivated when snd-pcsp is built... I would
> not get any tone out of that piece of hardware.
> Except if snd-pcsp itself contains beep code, and that would
> be sort of redundant when it is already in pcspkr.

It does contain exactly that -- snd-pcsp also provides the old input 
driver when compiled.

Rene.
