Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216Ab0AUVDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0AUVDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145Ab0AUVDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:03:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:55467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab0AUVDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:03:17 -0500
Message-ID: <4B58C0E8.2050205@kernel.org>
Date: Thu, 21 Jan 2010 13:02:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/36] x86: check range in update range
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org> <1264055303-15123-3-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001211443030.13130@router.home>
In-Reply-To: <alpine.DEB.2.00.1001211443030.13130@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 12:43 PM, Christoph Lameter wrote:
> On Wed, 20 Jan 2010, Yinghai Lu wrote:
> 
>> -v2: update comments
> 
> Dont see any comments being added.
----------------------------
so later could use it with 32bit amd_bus/intel_bus, and it could have cap_resource.
----------------------------


