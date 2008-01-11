Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbYAKOZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbYAKOZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758475AbYAKOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:25:04 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:41342 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbYAKOZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:25:01 -0500
Message-ID: <47877B83.5040604@keyaccess.nl>
Date: Fri, 11 Jan 2008 15:21:55 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Ondrej Zary <linux@rainbow-software.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with
 snd_cs4236
References: <200801092343.48726.linux@rainbow-software.org>	<47857A82.4050005@keyaccess.nl>	<Pine.LNX.4.61.0801100849290.30240@tm8103.perex-int.cz>	<4786C40B.8050005@keyaccess.nl> <20080111080141.75aaad5f@poseidon.drzeus.cx>
In-Reply-To: <20080111080141.75aaad5f@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-08 08:01, Pierre Ossman wrote:

> On Fri, 11 Jan 2008 02:19:07 +0100
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> I see a PnP resume _consists_ of setting the resources so I can see the test 
>> implementation wise, but yes, conceptually it seems this test shouldn't be 
>> present. So just like the attached then?
>>
>> Pierre, what was the idea here? Added the other SOBs to the CC as well...
>>
> 
> You assume there was an idea? ;)
> 
> I don't remember why things were done the way they were. And I can't find
> any clues in the correspondence around the issue. So your guess is as
> good as mine.

Hrmpf. Well, okay. Ondrej -- I assume this patch fixes things?

Rene.
