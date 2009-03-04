Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZCDSBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZCDSBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZCDSBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:01:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55603 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbZCDSBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:01:03 -0500
Message-ID: <49AEC1CA.50405@redhat.com>
Date: Wed, 04 Mar 2009 13:00:42 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] fix DMI for EFI
References: <49A9F597.4010601@redhat.com> <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com> <49ADEDA3.1030406@redhat.com> <20090304110022.GB18165@elte.hu> <49AE9850.9020103@redhat.com> <20090304175418.GB29823@elte.hu>
In-Reply-To: <20090304175418.GB29823@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Your patch looks fine, but i'd like to hear the opinion of Ying 
>Huang as well.

	
I had asked him to look at this before I posted and he had no objections. He may have an opinion on moving dmi scan into efi_init, though this can certainly be done later if and when needed.

Brian
 


