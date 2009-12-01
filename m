Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbZLAGlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbZLAGlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZLAGlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:41:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44799 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZLAGlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:41:11 -0500
Message-ID: <4B14BA8C.3090500@cs.helsinki.fi>
Date: Tue, 01 Dec 2009 08:41:16 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] SLAB: Make synthetic benchmark output more readable
References: <1259486553-4037-1-git-send-email-penberg@cs.helsinki.fi> <alpine.DEB.2.00.0911301333150.30639@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0911301333150.30639@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Nov 2009, Pekka Enberg wrote:
>> This patch makes the synthetic SLAB benchmark output easier to read by hymans
>> and easier to post-process with scripts. The output looks as follows:

David Rientjes kirjoitti:
> Pekka, are you looking to push slab_test.c through your tree?  If so, it 
> might make it easier to get the other tests (vmstat_test and 
> pagealloc_test) added through Andrew.

Yes, I am. I'm just waiting for Christoph to ACK/NAK my readability 
updates before putting it in linux-next.

			Pekka
