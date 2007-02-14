Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbXBNMwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbXBNMwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbXBNMwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:52:43 -0500
Received: from javad.com ([216.122.176.236]:3440 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbXBNMwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:52:42 -0500
From: Sergei Organov <osv@javad.com>
To: Olivier Galibert <galibert@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "J.A. =?utf-8?B?TWFn?= =?utf-8?B?YWxsw4PDg8OCwrNu?=" 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	<87ps8end9b.fsf@javad.com> <20070213222125.GB68966@dspnet.fr.eu.org>
Date: Wed, 14 Feb 2007 15:52:18 +0300
In-Reply-To: <20070213222125.GB68966@dspnet.fr.eu.org> (Olivier Galibert's
	message of "Tue, 13 Feb 2007 23:21:25 +0100")
Message-ID: <877iuknbp9.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert <galibert@pobox.com> writes:
> On Tue, Feb 13, 2007 at 09:06:24PM +0300, Sergei Organov wrote:
[...]
>> May I suggest another definition for a warning being entirely sucks?
>> "The warning is entirely sucks if and only if it never has true
>> positives." In all other cases it's only more or less sucks, IMHO.
>
> That means a warning that triggers on every line saying "there may be
> a bug there" does not entirely suck?

You got me. This warning is indeed entirely sucks. My definition is
poor.

-- Sergei.
