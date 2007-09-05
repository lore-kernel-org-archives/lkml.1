Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbXIEQeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbXIEQeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbXIEQeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:34:15 -0400
Received: from lucidpixels.com ([75.144.35.66]:53703 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbXIEQeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:34:14 -0400
Date: Wed, 5 Sep 2007 12:34:13 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: modinfo <modulename> question
Message-ID: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there anyway to get/see what parameters were passed to a kernel module? 
Running modinfo -p <module> will show the defaults, but for example, st, 
the scsi tape driver, is there a way to see what it is currently using? I 
know in dmesg it shows this when you load it initially (but if say dmesg 
has been cleared or the buffer was filled up)?


