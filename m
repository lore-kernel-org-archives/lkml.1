Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0BSB1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:27:08 -0500
Received: from mga06.intel.com ([134.134.136.21]:34162 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994Ab0BSB1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:27:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,500,1262592000"; 
   d="scan'208";a="597195620"
Message-ID: <4B7DE8E7.3090305@linux.intel.com>
Date: Thu, 18 Feb 2010 17:27:03 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mm: Make copy_from_user() in migrate.c statically predictable
References: <alpine.LFD.2.00.1002181447080.4141@localhost.localdomain> <4B7DD89F.4050003@linux.intel.com> <20100219102247.B939.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100219102247.B939.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 05:25 PM, KOSAKI Motohiro wrote:
>>
>> Updated patch, which compile-tests for me, attached.
> 
> hehe, I'm ESPer. I think you hope I do runtime-test, plz wait 12 hour :-)
> 

That would be most appreciated ;)

	-hpa

