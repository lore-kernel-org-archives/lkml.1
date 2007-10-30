Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbXJ3JXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbXJ3JXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbXJ3JV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:21:58 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:56591 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbXJ3JVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:21:54 -0400
Message-ID: <4726F795.70101@nttdata.co.jp>
Date: Tue, 30 Oct 2007 18:21:25 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: casey@schaufler-ca.com, Chris Wright <chrisw@sous-sol.org>,
       Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
References: <183239.5113.qm@web36604.mail.mud.yahoo.com> <4726A3A2.7060205@nttdata.co.jp> <Pine.LNX.4.64.0710300936500.31325@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710300936500.31325@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2007 09:21:27.0737 (UTC) FILETIME=[3FE53A90:01C81AD6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2007 5:40 PM, Jan Engelhardt wrote:
> On Oct 30 2007 12:23, Toshiharu Harada wrote:
>> Instead of pushing TOMOYO Linux, I started developing
>> comparison chart of security-enhance Linux implementations.
>> The current version can be found in
>>
>> http://tomoyo.sourceforge.jp/wiki-e/?WhatIs#comparison
> 
> Smack Security Model: autolabel, as far as I can tell.
I noticed the smell of danger in the naming of "Security Model".
Please allow me some time.

> Smack Policy Generation: user - hand - and an editor
> Apparmor tutorial (beats any FAQ at first):
> 	ftp://ftp.belnet.be/pub/mirror/FOSDEM/FOSDEM2006-apparmor.avi
Updated above two items. Thank you. :)

I'm not an optimist to believe we can reach the perfect
comparison. The purpose is to feed information, not to judge.
This might sound ironically, but I don't really think
we can *compare* them because they have different
theories/purposes/backgrounds. Some kind of forgiveness and
fuzziness are required.

As I don't want to steal everybody's bandwidth,
simple updates will be done silently. Your suggestions and
information will be greatly appreciated despite of
visible evidence.

Thank you.
Toshiharu Harada

