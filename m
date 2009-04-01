Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbZDAWJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbZDAWJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZDAWJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:09:39 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43798 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZDAWJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=mrErqRnEBD//fO2RKZ1gsZ/+SLJkMC1GAv/iyWt3JPfkpNgbQkBhOmyyA+81pespVj
         dmH/5hPKtTt4T6562JgBe4lP1RCMwX9anzv2soOETYFuTmFaHqTYZhVtkk7hnBUEFXC1
         wgE08pWBb6fVR2Oysz+q0xOXCY37qZSuGME7s=
Date: Thu, 2 Apr 2009 00:09:25 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Harald Arnesen <skogtun.harald@gmail.com>
Cc: david@lang.hm, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-ID: <20090402000925.1e728d7e@varda>
In-Reply-To: <87hc183uhn.fsf@basilikum.skogtun.org>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	<49CD7B10.7010601@garzik.org>
	<49CD891A.7030103@rtr.ca>
	<49CD9047.4060500@garzik.org>
	<49CE2633.2000903@s5r6.in-berlin.de>
	<49CE3186.8090903@garzik.org>
	<49CE35AE.1080702@s5r6.in-berlin.de>
	<49CE3F74.6090103@rtr.ca>
	<20090329231451.GR26138@disturbed>
	<20090330003948.GA13356@mit.edu>
	<49D0710A.1030805@ursus.ath.cx>
	<gqr50k$4aq$1@ger.gmane.org>
	<alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm>
	<49D3954A.9010309@tmr.com>
	<alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm>
	<87hc183uhn.fsf@basilikum.skogtun.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 02 Apr 2009 00:00:04 +0200
Harald Arnesen <skogtun.harald@gmail.com> escribió:


> 
> I've been wondering about that during the last days. How abut JFS and
> data loss (files containing zeroes after a crash), as compared to ext3,
> ext4, ordered and writeback journal modes? Is is safe?

  i have had zeroed conf files with jfs (shell history) and corrupted firefox
 history files too after power outages and the like.

