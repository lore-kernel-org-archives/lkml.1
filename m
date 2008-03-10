Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYCJWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYCJWdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYCJWdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:33:08 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:49594 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYCJWdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:33:07 -0400
Message-ID: <47D5B741.6010702@keyaccess.nl>
Date: Mon, 10 Mar 2008 23:33:37 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080310222211.2A0BEDBA2@gherkin.frus.com>
In-Reply-To: <20080310222211.2A0BEDBA2@gherkin.frus.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-03-08 23:22, Bob Tracy wrote:

> Rene Herman wrote:

>> Bob? How short are "short" wav files by the way?
> 
> The one I was using for testing is 50,272 bytes. A slightly longer file 
> that exhibits "more exotic" looping behavior is 97,898 bytes (just a bit 
> over 6 seconds of audio). I'll send you the shorter file under separate 
> cover.

Thanks. No problems here, using either the ALSA or OSS interfaces. Have been 
busy switching cards -- I have no hardware that can use anything other than 
DMA 0, 1 or 3. First test is to see if it's ALSA or just the OSS emulation 
though...

Rene.

