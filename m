Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZAFWGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZAFWGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZAFWGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:06:37 -0500
Received: from mx0.towertech.it ([213.215.222.73]:42199 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750924AbZAFWGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:06:36 -0500
Date: Tue, 6 Jan 2009 23:06:33 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: BARRE Sebastien <sbarre@sdelcc.com>
Cc: Ed Swierk <eswierk@aristanetworks.com>,
       "i2c@lm-sensors.org" <i2c@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Message-ID: <20090106230633.251c199e@i1501.lan.towertech.it>
In-Reply-To: <C1C62166118DFA4A8BBA01A2411F0D171224AECDC1@PRI-MBX-101.dom1.vinci-energies.net>
References: <1231176979.13443.19.camel@localhost.localdomain>
	<C1C62166118DFA4A8BBA01A2411F0D171224AECDC1@PRI-MBX-101.dom1.vinci-energies.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009 14:35:05 +0100
BARRE Sebastien <sbarre@sdelcc.com> wrote:

> > Reading or writing registers repeatedly until they stick is rather
> > nauseating but I'm aiming for correctness if not elegance.  I would
> > appreciate any suggestions for improvement.
> >
> > Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>  
> 
> I've read your patch quicly, I will test it on my board as soon as possible.

 Ok, I'll wait for a Tested-by before acking it.  

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

