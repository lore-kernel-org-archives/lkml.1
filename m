Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZGGRse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZGGRse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbZGGRs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:48:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39992 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101AbZGGRs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:48:26 -0400
Message-ID: <4A538A34.7060101@redhat.com>
Date: Tue, 07 Jul 2009 13:47:32 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/4] (Take 2): tmem: Core API between kernel and tmem
References: <e5a93cf7-c24c-4bfe-bc4c-c24eb8e0290d@default>
In-Reply-To: <e5a93cf7-c24c-4bfe-bc4c-c24eb8e0290d@default>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:
> Tmem [PATCH 1/4] (Take 2): Core API between kernel and tmem

I like the cleanup of your patch series.

However, what remains is a fair bit of code.

It would be good to have performance numbers before
deciding whether or not to merge all this code.
