Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbXE3JE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbXE3JE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXE3JER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:04:17 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:64076 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbXE3JEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:04:16 -0400
Message-ID: <465D3DB7.3090506@linux.vnet.ibm.com>
Date: Wed, 30 May 2007 14:32:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, menage@google.com, dev@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       pj@sgi.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
References: <20070529130104.461765000@menage.corp.google.com> <20070530001455.45cf1dc5.akpm@linux-foundation.org> <465D3141.305@linux.vnet.ibm.com> <465D3D91.5010807@openvz.org>
In-Reply-To: <465D3D91.5010807@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
>>> Is there any sneaky way in which we can modify the kernel so that this new
>>> code gets exercised more?  Obviously, tossing init into some default
>>> system-wide container would be a start.  But I wonder if we can be
>>> sneakier - for example, create a new container on each setuid(), toss the
>>> task into that.  Or something along those lines?
>> Please, lets get the RSS controller in. It's ready, been tested
> 
> It is not 100% ready yet actually :) I am working on it right now
> and hope to get ready till tomorrow.
> 

By ready, I meant ready for inclusion as a concept/approach.

>> and commented on widely.
> 
> Yup :) Balbir, thanks for testing, your patches are already in.
> 

Thanks for including them.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
