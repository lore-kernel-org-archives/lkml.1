Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZDEL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZDEL7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 07:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZDEL7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 07:59:11 -0400
Received: from lucidpixels.com ([75.144.35.66]:53505 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZDEL7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 07:59:10 -0400
Date: Sun, 5 Apr 2009 07:59:07 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29.1: kernel/console beep no longer available, audio problems
 too
Message-ID: <alpine.DEB.2.00.0904050756050.20631@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After upgrading from 2.6.28.2, I noticed 2.6.29.1 (the config option moved 
around too for the PC-speaker) that the audio for my sound card does not 
start working for 1-2 minutes after trying to play various sounds. 
Eventually, it starts to work, but the PC speaker no longer functions.

http://home.comcast.net/~jpiszcz/20090405/2.6.29.1-cfg.txt
http://home.comcast.net/~jpiszcz/20090405/2.6.28.2-cfg.txt

Is this a kernel/configuration issue or a bug since it appears the audio 
hw/configuration has been re-worked?

Justin.
