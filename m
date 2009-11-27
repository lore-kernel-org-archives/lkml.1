Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbZK0MWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbZK0MWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZK0MWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:22:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39631 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZK0MWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kNaJKGSlva29BcUt6p74AVtWw54gO7o1X8tZPYaAWeEF9tH/p3b5hQzmGKeqAsN1Zq
         f3T1PU7ezYhEqYQtO9voKFO9/lxmoynCKFu4GIVE5ZFx0BCEaFB1N6n5AGXj2C9oKLA2
         XBhic3oWXDQocMjhHrOZQkZADpJVq+0LIFz3U=
Message-ID: <4B0FC4A1.4080607@gmail.com>
Date: Fri, 27 Nov 2009 13:22:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       alsa-devel@alsa-project.org, fengguang.wu@intel.com
Subject: Re: ugly sound output (intel-hda) [was: mmotm 2009-11-24-16-47 uploaded]
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>	<4B0FAB00.9060805@gmail.com>	<s5hocmo1c11.wl%tiwai@suse.de>	<4B0FB2E2.3040801@gmail.com> <s5hskc0cj2d.wl%tiwai@suse.de>
In-Reply-To: <s5hskc0cj2d.wl%tiwai@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2009 12:18 PM, Takashi Iwai wrote:
> Just to be sure -- which h/w vendor/machine is it?

It's an intel development box -- intel motherboard with integrated sound.

-- 
js
