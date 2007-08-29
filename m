Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbXH2PnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbXH2PnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXH2PnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:43:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:25721 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbXH2PnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:43:00 -0400
Message-ID: <3db1ec7f0708290842y176c48eck9f39131a107756f9@mail.gmail.com>
Date: Wed, 29 Aug 2007 18:42:56 +0300
From: "Ivan N. Zlatev" <contact@i-nz.net>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/4] 2.6.23-rc4: known regressions
Cc: "Takashi Iwai" <tiwai@suse.de>, "Thomas Meyer" <thomas@m3y3r.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46D59052.6040609@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D58CC6.4020605@googlemail.com> <46D59052.6040609@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> ALSA
>
> Subject         : Master volume control broken
> References      : http://lkml.org/lkml/2007/8/18/46
> Last known good : ?
> Submitter       : Thomas Meyer <thomas@m3y3r.de>
> Caused-By       : Ivan N. Zlatev <contact@i-nz.net>
>                   commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1
> Handled-By      : Ivan N. Zlatev <contact@i-nz.net>
> Status          : problem is being debugged
>
>

Hello,

I am not the one to handle the issue. I have just supplied the
pinconfigs for the intel mac cards and assisted with logs/debug
information, so I happen to be more of an end user. I am not familiar
with the code base of the Intel HDA Codec. Takashi Iwai is the one
with the knowledge to fix the problem.

Regards.

-- 
Ivan N. Zlatev

Web: http://www.i-nZ.net
"It's all some kind of whacked out conspiracy."
