Return-Path: <linux-kernel-owner+w=401wt.eu-S936510AbYBCJdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936510AbYBCJdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759058AbYBCJd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:33:28 -0500
Received: from kuber.nabble.com ([216.139.236.158]:50046 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbYBCJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:33:27 -0500
Message-ID: <15251802.post@talk.nabble.com>
Date: Sun, 3 Feb 2008 01:33:26 -0800 (PST)
From: Martin Bauer <bluescreen@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
In-Reply-To: <15239145.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: bluescreen@web.de
References: <477A93CD.9030707@rrz.uni-koeln.de> <20080105065233.GE27894@ZenIV.linux.org.uk> <47801D70.8020504@uni-koeln.de> <20080106001756.GP27894@ZenIV.linux.org.uk> <47812E5B.6080000@uni-koeln.de> <20080106201559.GU27894@ZenIV.linux.org.uk> <478144E4.501@uni-koeln.de> <20080106234528.GV27894@ZenIV.linux.org.uk> <47829192.7030403@uni-koeln.de> <15239145.post@talk.nabble.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

ok the problem has been solved. It was really to late yesterday... I found
the two patches and applied those.  Because I had another error with the
Areca kernel modul I did some mistakes in my test...

Sorry...

Regards
Martin


Martin Bauer wrote:
> 
> I saw that you have problems with Ooops in evdev_disconnect. My problem is
> similar I have a USB KVM switch and if I switch beetween computers U got a
> Oops in evdev_disconnect (the first one is Kernel 2.6.23.12 and the second
> Kernel 2.6.24, both has this problem). My question is, can you tell me
> which two patches you have applied to solve the problem? I didn't found
> the right thing?
> 

-- 
View this message in context: http://www.nabble.com/Oops-in-evdev_disconnect-for-kernel-2.6.23.12-tp14569588p15251802.html
Sent from the linux-kernel mailing list archive at Nabble.com.

