Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYG3Tfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYG3Tfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYG3Tf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:35:26 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:14509 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbYG3TfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:35:24 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Roland Dreier <rdreier@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Date: Wed, 30 Jul 2008 19:34:29 +0000
Subject: RE: Problems building 2.6.26 and 2.6.27-rc1
Thread-Topic: Problems building 2.6.26 and 2.6.27-rc1
Thread-Index: AcjyeeXD3Jp9uIJYT5mI9vPg5QvvJQAAIIPQ
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3E8115C@GVW0547EXC.americas.hpqcorp.net>
References: <20080730184833.GA936@roadking.ldev.net>
	<adaiqunyyxd.fsf@cisco.com>
	<0F5B06BAB751E047AB5C87D1F77A778826B3E81120@GVW0547EXC.americas.hpqcorp.net>
 <ada7ib3yy3v.fsf@cisco.com>
In-Reply-To: <ada7ib3yy3v.fsf@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland wrote:

>
> Hmm, doesn't reproduce here with your config and gcc 4.1.
>
> No idea, sorry.

Thanks for taking a look. This is perplexing. I know I've built this kernel, but sometimes I hit the build bug and sometimes I don't. I can't pinpoint any differences between working and non-working builds.

Anybody else? :)

-- mikem
