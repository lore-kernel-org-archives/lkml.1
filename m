Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbXEXHg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbXEXHg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXEXHgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:36:48 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:44410 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbXEXHgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:36:47 -0400
Message-ID: <4655407A.4090104@linux.vnet.ibm.com>
Date: Thu, 24 May 2007 13:06:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Kirill Korotaev <dev@sw.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, Pavel Emelianov <xemul@sw.ru>,
       Paul Menage <menage@google.com>, devel@openvz.org,
       Linux Containers <containers@lists.osdl.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: RSS controller v2 Test results (lmbench )
References: <464C95D4.7070806@linux.vnet.ibm.com> <20070517112357.7adc4763.akpm@linux-foundation.org> <4651B4BF.9040608@sw.ru>
In-Reply-To: <4651B4BF.9040608@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev wrote:
>> Where do we stand on all of this now anyway?  I was thinking of getting Paul's
>> changes into -mm soon, see what sort of calamities that brings about.
> I think we can merge Paul's patches with *interfaces* and then switch to
> developing/reviewing/commiting resource subsytems.
> RSS control had good feedback so far from a number of people
> and is a first candidate imho.
> 

Yes, I completely agree!

> Thanks,
> Kirill
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
