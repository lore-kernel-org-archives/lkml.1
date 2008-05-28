Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYE1NiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYE1NiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYE1NiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:38:10 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:39997 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYE1NiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:38:08 -0400
Message-ID: <483D5FED.7080709@linux.vnet.ibm.com>
Date: Wed, 28 May 2008 19:06:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
References: <20080523195506.084894989@redhat.com> <483B0077.7000207@linux.vnet.ibm.com> <20080526153318.29edc0b2@bree.surriel.com> <483D46CE.2020507@linux.vnet.ibm.com> <2f11576a0805280633p2be93911n3050c11861c1ebb@mail.gmail.com>
In-Reply-To: <2f11576a0805280633p2be93911n3050c11861c1ebb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi balir-san,
> 
>> I've run into a case where with the splitvm patches the memory controller
>> immediately OOMs a task in the cgroup on exceeding it's limit. I am going to try
>> and find the root cause for it.
> 
> I sent the patch of fix this problem.
> please see it.

Yes, I just saw it after I sent out my email. Let me try those patches. I'll
revert back


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
