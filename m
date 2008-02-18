Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbYBRVOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbYBRVOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYBRVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:14:41 -0500
Received: from mga10.intel.com ([192.55.52.92]:50399 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266AbYBRVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:14:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,373,1199692800"; 
   d="scan'208";a="299660873"
Message-ID: <47B9F4BA.8020900@linux.intel.com>
Date: Mon, 18 Feb 2008 13:12:26 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Laurent Riffard <laurent.riffard@free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47B9DDF4.8030605@linux.intel.com> <47B9F331.7070808@free.fr>
In-Reply-To: <47B9F331.7070808@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Riffard wrote:
> ioremap: trying to map RAM page at 0       <===============
> Completing Region/Field/Buffer/Package 
> initialization:................................................
> 
> Hope this helps.

actually... it helps a lot.
I'll cook up a patch for this now :)
thanks for testing so quickly


