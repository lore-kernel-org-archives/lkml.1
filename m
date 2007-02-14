Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbXBNV55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbXBNV55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbXBNV54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:57:56 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:38657 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbXBNV54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:57:56 -0500
Date: Wed, 14 Feb 2007 22:57:08 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: sfaibish <sfaibish@emc.com>
cc: kernel list <linux-kernel@vger.kernel.org>,
       "piernas@ditec.um.es" <piernas@ditec.um.es>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com>
Message-ID: <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
 <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 14 2007 16:10, sfaibish wrote:
>> 
>> 1. DualFS has only one copy of every meta-data block. This copy is
>> in the meta-data device,

Where does this differ from typical filesystems like xfs?
At least ext3 and xfs have an option to store the log/journal
on another device too.

>> The DualFS code, tools and performance papers are available at:
>> 
>> <http://sourceforge.net/projects/dualfs>
>> 
>> The code requires kernel patches to 2.4.19 (oldies but goodies) and
>> a separate fsck code.  The latest kernel we used it for is 2.6.11
>> and we hope with you help to port it to the latest Linux kernel.

Where is the patch for 2.6.11? Sorry, 2.4.19 is just too old (even if 
only considering the 2.4 branch).
[ And perhaps "goldies" flew better with "oldies" ;-) ]


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
