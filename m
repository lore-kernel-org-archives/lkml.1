Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbZDNQQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbZDNQQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbZDNQQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:16:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675AbZDNQQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:16:17 -0400
Message-ID: <49E4B6D5.9060007@vlnb.net>
Date: Tue, 14 Apr 2009 20:16:21 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>,
       Andy Yan <ayan@marvell.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and 88SE94xx(6G)
 SAS cards
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+jmmrGHe8PV2BkdSqDvRYtG0y2MObg4VEqaVR
 6arNHoImOuA7RtHjZsenaM9Fi80yVVZo6XZUrrtyY4xFXtT+5D
 05Grqnd7zeGbGrRBeOK5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm glad to announce that a target driver for Marvell 88SE64xx(3G) and 
88SE94xx(6G) SAS cards has been just added in the SCST SVN repository. A 
lot of thanks to Marvell and Andy Yan!

This driver allows to use a SAS controller based on Marvell 88SE64xx or 
88SE94xx chips as a SAN storage server (target). More info you can find 
on the SCST page http://scst.sourceforge.net.

You can download the driver from SCST SVN by running a command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst

Vlad
