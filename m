Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZJMNBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZJMNBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZJMNBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:01:48 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46061 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZJMNBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:01:47 -0400
Message-ID: <4AD47A10.2080102@openvz.org>
Date: Tue, 13 Oct 2009 17:01:04 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, vatsa@in.ibm.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com> <4AD466E5.4010206@openvz.org> <20091013120354.GF24787@MAIL.13thfloor.at> <4AD4705D.6020109@openvz.org> <20091013123047.GC26069@linux.vnet.ibm.com> <4AD4765B.3010907@openvz.org> <20091013125737.GB3672@in.ibm.com>
In-Reply-To: <20091013125737.GB3672@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is what we have right now. All the groups will start with a default
> period (of .5s) and user has the option of changing it based on his
> requirement. However we need to find out if the default period is really
> "good for most users"

Is it? If so, then I'm fine with it. As I understood from the beginning
is that I'll _have_ to specify both numbers.

> Regards,
> Bharata.
> 

