Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYIPHNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYIPHNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 03:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYIPHM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 03:12:58 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:56226 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYIPHM5 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 03:12:57 -0400
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 03:12:57 EDT
Date: Tue, 16 Sep 2008 08:57:43 +0200 (CEST)
From: Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw.se.axis.com
To: Jamie Lokier <jamie@shareable.org>
cc: Jared Hulbert <jaredeh@gmail.com>, "cotte@de.ibm.com" <cotte@de.ibm.com>,
       Greg Ungerer <gerg@snapgear.com>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       =?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       "Linux-kernel@vger.kernel.org" <Linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "tim.bird@am.sony.com" <tim.bird@am.sony.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
In-Reply-To: <20080915163421.GA13631@shareable.org>
Message-ID: <Pine.LNX.4.64.0809160856190.5966@lnxricardw.se.axis.com>
References: <20080915163421.GA13631@shareable.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 15 Sep 2008, Jamie Lokier wrote:

> This is all very interesting - I had no prior experience with NOR, so
> didn't know that 0.6MB/s was slow.  It's fast compared with older
> EEPROMs after all, and had imagined that people wanting fast flash
> would use NAND.
>

NAND is significantly faster when writing than NOR, read speed is of the 
same magnitude, possibly slower in many cases.

/Ricard
--
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
    "With Free Software you are employing the best programmers on the planet"
