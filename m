Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYFJBja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYFJBja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 21:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYFJBjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 21:39:20 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:22614 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYFJBjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 21:39:19 -0400
X-BigFish: VPS-37(z1fc9iz1432R98dR7efV1805Mzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 7,
Message-ID: <484DDAD9.2000306@am.sony.com>
Date: Mon, 9 Jun 2008 18:37:29 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Adrian Bunk <adrian.bunk@movial.fi>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: mainlining min-configs...
References: <48447615.5050806@am.sony.com> <20080604194002.GF4189@cs181133002.pp.htv.fi> <4849CCA3.7040102@am.sony.com> <200806062329.54019.rob@landley.net>
In-Reply-To: <200806062329.54019.rob@landley.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 01:39:06.0580 (UTC) FILETIME=[C5689940:01C8CA9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Friday 06 June 2008 18:47:47 Tim Bird wrote:
>> At a minimum, it would be nice to have a few nice examples
>> of really, really small configs for things like qemus for different
>> architectures (just to give embedded developers who are working
>> on size a starting point).
> 
> That's more or less what I'm trying to do with my Firmware Linux project: 
> creating cross compilers and minimal native build environments for every qemu 
> target.

Any chance of getting your minimal configs from Firmware Linux mainlined?

Does anyone else think this would be valuable?  If not in mainline, it
would be nice to collect them somewhere, to compare what options different
developers decide turn on or off.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

