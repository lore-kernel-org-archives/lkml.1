Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbZCXT1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbZCXT1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbZCXT1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:27:20 -0400
Received: from cluster-a.mailcontrol.com ([85.115.52.190]:53127 "EHLO
	cluster-a.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761154AbZCXT1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:27:19 -0400
X-Greylist: delayed 2511 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 15:27:18 EDT
From: Train05 <Train05@EU.NEC.COM>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Mar 2009 18:45:16 +0000
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Thread-Topic: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Thread-Index: AQHJrLCs1OjWMmoTgkqMawF0c/Nopg==
Message-ID: <0ECEF3AEFC6FB34EB441B6010BE685EF58211083DD@EUEXCLU01.EU.NEC.COM>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

I experienced identical issues with the network stack hanging after a very short period with 2.6.29 and forcedeth (transferring a few megabytes was normally enough).  I applied your patch and it is now working correctly.

Many thanks

Ross

Ross Alexander
SAP Basis
NEC Europe Ltd
Corporate IT Centre
Tel:     +44 20 8752 3394
