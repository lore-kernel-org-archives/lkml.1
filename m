Return-Path: <linux-kernel-owner+w=401wt.eu-S1765024AbZDBQcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765024AbZDBQcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZDBQc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:32:26 -0400
Received: from h155.mvista.com ([63.81.120.155]:10081 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752337AbZDBQc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:32:26 -0400
Message-ID: <49D4E8B8.5000301@ru.mvista.com>
Date: Thu, 02 Apr 2009 20:32:56 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 3/5] ata: Add TRIM infrastructure
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <49D4DFFB.8070201@ru.mvista.com> <20090402161835.GN2661@linux.intel.com>
In-Reply-To: <20090402161835.GN2661@linux.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:

>>   I wonder where to read about the word 169 and commnand 0x06... what's 
>>it all about?

> It's in d2015r1-ATAATAPI_Command_Set_-_2_ACS-2.pdf which can be found on
> the t13 website.

    But since neither ATA/PI-7 nor ATA/PI-8 mention neither the word nor 
command, why your validity check requires only ATA/PI-7+ compliance?

MBR, Sergei
