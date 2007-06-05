Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbXFEOop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbXFEOop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932144AbXFEOoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:44:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32217 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765203AbXFEOoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=C9j2JvIIFcNy7UZVw5iVQHqDqFLnix9mhwCIlhdU8TMOjcjFdaI8hUQpbhuGqphAtysGLaPt5d0G4RhLy9Nqhr/O1Q+gen2SMb/0b4HRyjma4nGfmzf4zi+OE2R6Lm/vPc91UmvMEC8bD5s+6HYDDdP3T7eZ5iPutfx5cSMIqYU=
Message-ID: <466576A4.30701@googlemail.com>
Date: Tue, 05 Jun 2007 16:43:48 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Thierry Volpiatto <tvolpiatt@neuf.fr>,
       Marc Tuerschmann <marc@tuerschmann.de>,
       Denis Sadykov <denis.m.sadykov@intel.com>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>, linux-fsdevel@vger.kernel.org,
       Alex Riesen <raa.lkml@gmail.com>
Subject: Re: [2/5] 2.6.22-rc4: known regressions
References: <46657407.1000108@googlemail.com>
In-Reply-To: <46657407.1000108@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



ACPI

Subject    : ACPI_CPUFREQ fails to load - HP ML110 G4 Xeon 3040
References : http://bugzilla.kernel.org/show_bug.cgi?id=8570
Submitter  : Marc Tuerschmann <marc@tuerschmann.de>
Status     : Unknown
             (possible hardware issues)

Subject    : unable to shutdown on kernel 2.6.22-rc2
References : http://bugzilla.kernel.org/show_bug.cgi?id=8516
Submitter  : Thierry Volpiatto <tvolpiatt@neuf.fr>
Status     : Unknown



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Status     : Unknown


File systems

Subject    : OOPS (NULL pointer dereference) in v2.6.22-rc3
References : http://lkml.org/lkml/2007/6/1/389
Submitter  : Alex Riesen <raa.lkml@gmail.com>
Status     : Unknown



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

