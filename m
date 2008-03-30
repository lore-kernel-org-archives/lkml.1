Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbYC3KCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYC3KCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 06:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYC3KCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 06:02:45 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:38644 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbYC3KCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 06:02:44 -0400
Message-ID: <47EF6540.1020808@orcon.net.nz>
Date: Sun, 30 Mar 2008 23:02:40 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080330051814.5D9CCDBA2@gherkin.frus.com>
In-Reply-To: <20080330051814.5D9CCDBA2@gherkin.frus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Sun, 30 Mar 2008 23:02:42 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Mar 30 23:02:43 2008
X-DSPAM-Confidence: 0.6157
X-DSPAM-Improbability: 1 in 161 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Tracy wrote:
> Rene Herman wrote:
>> $ sox asskickd.wav -w -r 44100 -t alsa hw
> 
> Several seconds of silence, followed by what sounded like continuous pitched
> machine-gun fire.  Each <ctrl>C advanced through the file (the pitch of the
> machine-gun fire changed slightly).  Still had to type <ctrl>\ to kill sox.

Right, that sounds just like the older PWS600au I have - the one with 
the ESS1888 - except that what Bob describes as machine gun fire, I 
thought was, ahem, flatulence.

The newer PWS600au (with the ESS1887) plays the sound files correctly, 
except for the repeated bits at the end.

Michael.
