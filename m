Return-Path: <linux-kernel-owner+w=401wt.eu-S1030393AbXBTVIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030393AbXBTVIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030394AbXBTVIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:08:05 -0500
Received: from mail0.lsil.com ([147.145.40.20]:48704 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030393AbXBTVIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:08:02 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6 patch] make mptspi_target_destroy() static
Date: Tue, 20 Feb 2007 14:00:18 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D705AD0EE@NAMAIL4.ad.lsil.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] make mptspi_target_destroy() static
Thread-Index: AcdUgxqPMLf6iWptTkSMfdBcRSOO6AArtnxg
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Adrian Bunk" <bunk@stusta.de>
Cc: "James Bottomley" <James.Bottomley@SteelEye.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Feb 2007 21:00:19.0027 (UTC) FILETIME=[20CB5230:01C75532]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 19, 2007 5:07 PM,  Adrian Bunk wrote:

> This patch makes the needlessly global mptspi_target_destroy() static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 

ACK
