Return-Path: <linux-kernel-owner+w=401wt.eu-S1766879AbXDSQ7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766879AbXDSQ7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766881AbXDSQ7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:59:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766879AbXDSQ7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:59:51 -0400
Message-ID: <4627A000.1030509@redhat.com>
Date: Thu, 19 Apr 2007 12:59:44 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <ak@suse.de>, discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: Dropping CONFIG_REORDER on x86-64 for 2.6.22
References: <200704191354.52985.ak@suse.de> <46277C36.6030301@linux.intel.com>
In-Reply-To: <46277C36.6030301@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Andi Kleen wrote:
>> Rationale:
>> - It cannot be enabled in normal builds because all current lds
>> become very slow when they have to handle thousands of sections.
>>
> 
> afaik this is only ever reported on SuSE; I've not heard it on any other
> distro...

It's horribly slow on Fedora.

