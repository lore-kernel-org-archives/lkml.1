Return-Path: <linux-kernel-owner+w=401wt.eu-S1161090AbXBOTsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161090AbXBOTsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161092AbXBOTsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:48:35 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:56206 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161090AbXBOTse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:48:34 -0500
Date: Thu, 15 Feb 2007 20:46:34 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Juan Piernas Canovas <piernas@ditec.um.es>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <p73sld7f96t.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.61.0702152044450.17168@yvahk01.tjqt.qr>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
 <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <p73sld7f96t.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15 2007 21:38, Andi Kleen wrote:
>
>Also I would expect your design to be slow for metadata read intensive
>workloads. E.g. have you tried to boot a root partition with dual fs?
>That's a very important IO benchmark for desktop Linux systems.

Did someone say metadata intensive? Try kernel tarballs, they're a
perfect workload. Tons of directories, and even more files here and
there. Works wonders.


Jan
-- 
