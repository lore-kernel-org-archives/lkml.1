Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbXJVLuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbXJVLuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXJVLtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:49:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:44359 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbXJVLtm (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:49:42 -0400
Message-ID: <471C8E28.9020707@qumranet.com>
Date: Mon, 22 Oct 2007 13:48:56 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: carsteno@de.ibm.com
CC: carsteno@linux.vnet.ibm.com,
       "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <4718C9A1.3010703@qumranet.com> <471C821A.8020500@de.ibm.com>
In-Reply-To: <471C821A.8020500@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte wrote:
> Avi Kivity wrote:
>> kvm.git is actually 2.6.24-rc, pulled from -linus at a random point in
>> time, so it's not at all surprising if something is broken.
> Right. We have a backup now, so next time we'll be ok ;-). Would you 
> please pull from Linus again to get the fix into kvm.git so that we 
> can use your tree on that machine again?
>

I pulled yesterday so it should be all right (and you don't need me for 
that; you can pull from Linus on top of kvm.git).


-- 
error compiling committee.c: too many arguments to function

