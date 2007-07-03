Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbXGCGjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbXGCGjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbXGCGiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:38:51 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:59205 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbXGCGiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:38:50 -0400
Message-ID: <4689EEC5.4040005@linux.vnet.ibm.com>
Date: Tue, 03 Jul 2007 12:07:57 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: cmm@us.ibm.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
References: <1183275416.4010.125.camel@localhost.localdomain>
In-Reply-To: <1183275416.4010.125.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Mingming Cao wrote:
> This patch is a spinoff of the old nanosecond patches.
> 
> It includes some cleanups and addition of a creation timestamp. The
> EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
> s

Should be EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE

-aneesh
