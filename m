Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab0CCV6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:58:38 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:42852 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756810Ab0CCV6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:58:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBADdqjktLd/sX/2dsb2JhbAAHgwC/K5A1gTWCXWoEgxc
X-IronPort-AV: E=Sophos;i="4.49,576,1262581200"; 
   d="scan'208";a="57439717"
Message-ID: <4B8EDB77.2060206@teksavvy.com>
Date: Wed, 03 Mar 2010 16:58:15 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] ahci: Move generic code into libahci
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru> <20100303171747.GI12362@oksana.dev.rtsoft.ru> <4B8EADE5.5010109@pobox.com>
In-Reply-To: <4B8EADE5.5010109@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/10 13:43, Jeff Garzik wrote:
> On 03/03/2010 12:17 PM, Anton Vorontsov wrote:
>> This patch should contain no functional changes, just moves code
>> around.
>
> Excellent! I like how this patch series is split up.
..

Yes.  Excellent work!
