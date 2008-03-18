Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYCRDyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYCRDyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 23:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYCRDyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 23:54:10 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:32952 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYCRDyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 23:54:09 -0400
Cc: Rene Herman <rene.herman@keyaccess.nl>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Message-Id: <546A47FE-F98E-49E2-A250-41F65C2D482B@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Bob Tracy <rct@frus.com>
In-Reply-To: <20080318032427.298BCDBA2@gherkin.frus.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
Date: Tue, 18 Mar 2008 16:54:04 +1300
References: <20080318032427.298BCDBA2@gherkin.frus.com>
X-Mailer: Apple Mail (2.919.2)
X-DSPAM-Check: by mx3.orcon.net.nz on Tue, 18 Mar 2008 16:54:06 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Mar 18 16:54:06 2008
X-DSPAM-Confidence: 0.8003
X-DSPAM-Improbability: 1 in 402 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/03/2008, at 4:24 PM, Bob Tracy wrote:

> I'll try the below when I get back from my business trip (in approx.
> two weeks).  Apologies for the inconvenience, but the Alpha hardly
> qualifies as a laptop :-).  If someone else with a Miata (or other
> Alpha with the ES1888 sound device) cares to give this a try, I *will*
> be keeping up with my e-mail.

I should be able to give this a go over Easter on a PWS500au, which,  
IIRC, is a miata system.

As an aside, I have been using the ESS1888 on my XP1000 (in between  
system partition corruptions and restoring the system three times - I  
suspect a failing controller card which I have now removed) through  
the OSS interface for a couple of weeks without problems.  This is  
indicative that the ESS1888 problem may be specific to certain Alpha  
models.

Michael.

