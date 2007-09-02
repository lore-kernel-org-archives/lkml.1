Return-Path: <linux-kernel-owner+w=401wt.eu-S933787AbXIBWU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbXIBWU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbXIBWUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:20:50 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:57974 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbXIBWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:20:49 -0400
Message-ID: <46DB35CA.2010907@gmail.com>
Date: Mon, 03 Sep 2007 00:14:34 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH -mm] es18xx: Shut up uninitialized var build warning
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030150180.29617@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709030150180.29617@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2007 10:21 PM, Satyam Sharma wrote:

> sound/isa/es18xx.c: In function ‘snd_es18xx_isa_probe’:
> sound/isa/es18xx.c:2251: warning: ‘err’ may be used uninitialized in this function
> 
> gcc is a sad, sad compiler. This warning is bogus so let's shut it up.

Same situation, same comment (and same charset :-( ) as the sb16 one.

Rene.
