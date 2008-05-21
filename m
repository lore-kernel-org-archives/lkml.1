Return-Path: <linux-kernel-owner+w=401wt.eu-S937306AbYEUWFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937306AbYEUWFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbYEUWFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:05:33 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:45817 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYEUWFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:05:33 -0400
Message-ID: <48349D43.8020003@keyaccess.nl>
Date: Thu, 22 May 2008 00:08:03 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] Moving sound/* to drivers/ ?
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <48349AF2.30009@keyaccess.nl>
In-Reply-To: <48349AF2.30009@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 23:58, Rene Herman wrote:

> On 21-05-08 23:44, Linus Torvalds wrote:
> 
>> So I would personally certainly not mind somebody doing a
>>     git mv sound drivers/sound
>>     .. edit makefiles and Kconfig files appropriately ..
>>     git commit -a
>>
>> and it wouldn't be a problem for git (ie the repository wouldn't grow 
>> or anything like that).
> 
> I'd personally like the net/ structure more. So subsystem code under 
> sound/ and drivers moved to drivers/sound/.

Suggestion for sound/drivers: drivers/sound/generic :-)

Rene.
