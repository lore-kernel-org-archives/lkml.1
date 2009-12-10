Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbZLJSli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbZLJSli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761413AbZLJSlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:41:37 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:27384 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761428AbZLJSlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:41:36 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABLQIEurR7Ht/2dsb2JhbADAUZcPhCsE
X-IronPort-AV: E=Sophos;i="4.47,376,1257120000"; 
   d="scan'208";a="228213105"
From: Roland Dreier <rdreier@cisco.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk>
	<20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>
	<67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>
	<20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Dec 2009 10:41:42 -0800
In-Reply-To: <4B213F1F.2020305@kernel.org> (Yinghai Lu's message of "Thu, 10
	Dec 2009 10:34:07 -0800")
Message-ID: <adaocm6n02h.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Dec 2009 18:41:43.0015 (UTC) FILETIME=[6B109770:01CA79C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > mptable mpc is [12 - f011]

 > what a BIOS !

Can you be more explicit about what the BIOS is doing wrong?  

Jens, can you say what BIOS version (18, 19, 20, ...?) you're using?  I
think I know exactly what box you have.

I have a pretty good pipeline to the BIOS guys and I can try to get this
cleaned up if I know the details.

Thanks,
  Roland
