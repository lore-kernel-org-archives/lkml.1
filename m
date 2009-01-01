Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZAASoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZAASoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 13:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZAASn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 13:43:58 -0500
Received: from lucidpixels.com ([75.144.35.66]:49200 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZAASn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 13:43:57 -0500
Date: Thu, 1 Jan 2009 13:43:54 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Disk vibration video from Sun Microsystems ( .. and the effect on
 performance .. )
Message-ID: <alpine.DEB.1.10.0901011337390.18214@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was posted in a filesystem irc chat:
http://blogs.sun.com/brendan/entry/unusual_disk_latency

Pretty interesting stuff, it also makes you wonder how much resonance is 
acceptable for an array and besides using dtrace/etc how could one measure 
it?  I know with 3ware you can turn on dpmstat etc for the higher end 9xxx 
controllers to check iops per disk etc, but not all hosts may have 3ware 
controllers, so besides making sure you utilize anti-vibration 
devices/techniques (rubber washers etc) how could one measure this?

Justin.
