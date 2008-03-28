Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYC1EHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYC1EHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbYC1EH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:07:27 -0400
Received: from gw.goop.org ([64.81.55.164]:49718 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYC1EH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:07:27 -0400
Message-ID: <47EC6EEC.9060405@goop.org>
Date: Thu, 27 Mar 2008 21:07:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory
 is bad
References: <20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com> <47EC5D2E.8060001@goop.org> <20080328121530.B0C9.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20080328121530.B0C9.E1E9C6FF@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
> BTW, have you ever seen this slides? 
>
> http://www.linuxsymposium.org/2006/hotplug_slides.pdf
>
> I'm glad if his idea can help you.
>   

I hadn't seen that before, but its fairly similar to what I've implemented.

Thanks,
    J

