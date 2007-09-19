Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXISVhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXISVhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXISVhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:37:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:27280 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbXISVhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:37:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,275,1186383600"; 
   d="scan'208";a="282488814"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: what is the difference between shutdown command and writing to /sys/power/state
Date: Wed, 19 Sep 2007 14:37:03 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628ACF21D@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200709192334.30944.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: what is the difference between shutdown command and writing to /sys/power/state
Thread-Index: Acf7AyPWNF3A3WU1TQiiZV5I4nyupQAAdnPQ
References: <A3258B497F1C1441AD36A2E8B45FD628ACF018@scsmsx412.amr.corp.intel.com> <200709192334.30944.rjw@sisk.pl>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Sep 2007 21:37:03.0766 (UTC) FILETIME=[38150B60:01C7FB05]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can you tell me the differences?
Also what do you mean by - depending also on what you mean by 'now'? I
gave now as a time parameter to shutdown command. How can it be
interpreted in a different way?

-----Original Message-----
From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
Sent: Wednesday, September 19, 2007 2:35 PM
To: Agarwal, Lomesh
Cc: linux-kernel@vger.kernel.org
Subject: Re: what is the difference between shutdown command and writing
to /sys/power/state

On Wednesday, 19 September 2007 20:50, Agarwal, Lomesh wrote:
> Does linux handles writing "disk" to /sys/power/state and shutdown -P
> now differently (except writing to disk part)?

Yes, it does (depending also on what you mean by 'now').

Greetings,
Rafael
