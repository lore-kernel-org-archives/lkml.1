Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZEGIp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZEGIp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZEGIpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:45:17 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:41725 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752193AbZEGIpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:45:16 -0400
Message-ID: <4A029F9B.7060706@snapgear.com>
Date: Thu, 07 May 2009 18:45:15 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: failure at mm/nommu.c:518/add_nommu_region()
References: <4A0227AD.9030705@snapgear.com> <4A00EF23.4050302@snapgear.com> <49FF96A7.5040401@snapgear.com> <3662.1241530861@redhat.com> <30031.1241619079@redhat.com> <17346.1241685514@redhat.com>
In-Reply-To: <17346.1241685514@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

David Howells wrote:
> Greg Ungerer <gerg@snapgear.com> wrote:
> 
>> Yes, that fixes it :-)
> 
> Can I add your Acked-by or Tested-by?

Yes, absolutely:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
