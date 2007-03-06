Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbXCFMWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbXCFMWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXCFMWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:22:46 -0500
Received: from mx.laposte.net ([81.255.54.11]:18033 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXCFMWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:22:45 -0500
Message-ID: <14850.192.54.193.51.1173183673.squirrel@rousalka.dyndns.org>
Date: Tue, 6 Mar 2007 13:21:13 +0100 (CET)
Subject: Re: [linux-usb-devel] [DOC] The documentation for HID Simple 
     Driver
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: linux-kernel@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net
User-Agent: SquirrelMail/1.4.8-4.fc6
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> But (You may guess I will say this word :), before the HID bus or other
>> better
>> implementation come , I hope use the extended keys of my keyboard on
>> Linux, and I guess other people
>> also think same with me, so we need something here temporarily, even it
>> do not merge
>> into upstream code tree.

> And until something better comes along I am happy to use what Li Yu
> has produced (speaking as an ordinary user).

+1 as a stupid user I don't see the point of blocking a perfectly fine
driver because a better solution may happen someday (the proof is in the
pudding and people may still find stopper problems when coding it). At the
pace things are going the hardware will be end of lifed before this
solution happens.

Li Yu first drivers messages have more than a year now! Is the driver so
invasive it couldn't be deprecated later?

(also there is the slight problem of teaching X to accept > 255 keycodes,
which won't happen till there are popular drivers linux-side emitting
them)

-- 
Nicolas Mailhot

