Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbYGUQSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbYGUQSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYGUQRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:17:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbYGUQRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:52 -0400
Message-ID: <4884B68A.7070000@linux-foundation.org>
Date: Mon, 21 Jul 2008 11:17:14 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       riel@redhat.com
Subject: Re: [PATCH 1/8] slub: Add defrag_ratio field and sysfs support.
References: <Pine.LNX.4.64.0807191529450.13345@sbz-30.cs.Helsinki.FI>	 <20080719105239.4a89f64c.akpm@linux-foundation.org> <84144f020807200338s55074230he16cc3dda3b012e6@mail.gmail.com>
In-Reply-To: <84144f020807200338s55074230he16cc3dda3b012e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Andrew,
>
> On Sat, Jul 19, 2008 at 8:52 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>   
>> Were you planning on sending out the patches to wire all this up
>> to the notorious caches?
>>     
>
> No, I wasn't because don't have those patches in my tree (and I
> probably don't want them either). Christoph?
>   
I have those diffed against linux-next from a week ago or so and 
rc8-mm1. Want me to post them? Would be good to have a tree to submit 
against. rc8-mm1?

