Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYL3M0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYL3M0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYL3M0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:26:11 -0500
Received: from lucidpixels.com ([75.144.35.66]:54287 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYL3M0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:26:10 -0500
Date: Tue, 30 Dec 2008 07:26:09 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Status/support for Linux HECI from Intel? (for temp/voltage
 monitoring)
Message-ID: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HECI interface would allow lm_sensors developers to grab the 
temperatures off the chips on the board.

>From 2005(?)-2008 there was some chatter about supporting it but it never 
seemed to happen, is there any eventual planned support for supporting 
Intel's HECI interface or if the user wants to see the 
temperatures/voltages just buy a different motherboard with an ITE I/O 
controller?

I have a couple DG965WH boards and it would be nice to see the 
temperature of the chipset etc without having to reboot into the BIOS.

Justin.
