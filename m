Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbYGRBVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbYGRBVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYGRBVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:21:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:34761 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYGRBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=t1wGiJUqBoXq78grN60vRr4/zmAFZ56mS3yWY9tUOQM9zVz0MXCc/7ICDD5lGlHQ1+
         GlBd3h4+eKebOB8Tb7sCyavPzD+ZyEc+smq18O8i/9jrhx38lzCEYurfC+aumoo9F1Ls
         VIYzTtg+VY4Qw9zgj8Bf4u3JX5bgWbyG44swo=
Message-ID: <e9c3a7c20807171821i7d99e4d9p8bfd8c758a30b385@mail.gmail.com>
Date: Thu, 17 Jul 2008 18:21:12 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] async_tx: list_for_each_entry_rcu() cleanup
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <487EA7D2.6080706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <487EA7D2.6080706@cn.fujitsu.com>
X-Google-Sender-Auth: 71a52e70063234ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 7:00 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> In the rcu update side, don't use list_for_each_entry_rcu().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---

Thanks, applied.

--
Dan
