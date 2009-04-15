Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZDOP1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZDOP1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZDOP12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:27:28 -0400
Received: from mga12.intel.com ([143.182.124.36]:28768 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750966AbZDOP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:27:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,192,1239001200"; 
   d="scan'208";a="131761227"
Message-ID: <49E5FCD7.8060902@linux.intel.com>
Date: Wed, 15 Apr 2009 08:27:19 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-14-17-24 uploaded
References: <200904150024.n3F0Ovdo019569@imap1.linux-foundation.org> <22518.1239773374@turing-police.cc.vt.edu>
In-Reply-To: <22518.1239773374@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 14 Apr 2009 17:24:57 PDT, akpm@linux-foundation.org said:
>> The mm-of-the-moment snapshot 2009-04-14-17-24 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
> 
> patch input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
> is horribly busticated - was this dependent on another patch that was dropped?
> The reference to 'i8042_nonfatal' is odd, I can't find it defined anywhere in the tree.

it depends on a patch that now has gone mainline....

