Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbXCUQN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbXCUQN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXCUQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:13:47 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:5805 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932702AbXCUQNY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:13:24 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 12:13:24 EDT
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=zlzHmaPMp4KztdbLsVTVcP/nRdDsgaoUlbPOVEJo2d1nzjPUz2NOBvPvD2a1IHEwi9o5SDFggRBR9lJCkBqA9mh9vos0FoodaDSY34vXkGIhHSqYdsxMxz4O6HigtWOH;
X-SBRSScore: None
X-IronPort-AV: i="4.14,309,1170630000"; 
   d="scan'208"; a="62673269:sNHT27495148"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: how can I touch softlockup watchdog on all cpus?
Date: Wed, 21 Mar 2007 17:10:01 +0100
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F37@ABGEX01E.abg.fsc.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: how can I touch softlockup watchdog on all cpus?
Thread-Index: Acdr0uXUzQRkiPRBS2WyCNlFmDOOkwAAHPzA
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Mar 2007 16:09:58.0039 (UTC) FILETIME=[5F0E4270:01C76BD3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey again,

forgot to mention that I tried this patch, but did not work for me:
http://lkml.org/lkml/2007/3/15/131

Ciao Thilo
