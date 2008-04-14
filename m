Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbYDNOv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbYDNOv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYDNOvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:51:37 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52349 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYDNOvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:51:35 -0400
Message-ID: <48036F14.3050409@cs.helsinki.fi>
Date: Mon, 14 Apr 2008 17:49:56 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
References: <48036677.3010807@linux.vnet.ibm.com>
In-Reply-To: <48036677.3010807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> If nobody has any specific objection to this patch, can I go ahead and request
> Andrew to include this patch?

->owner in struct mm_struct is very useful for revokeat() so

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
