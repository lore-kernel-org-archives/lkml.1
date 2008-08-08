Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYHHIX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYHHIX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYHHIXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:23:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:58632 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYHHIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GBF6uia8iFMGAHDyNhl0+TDEvxLqZPRXPb/cNr23jTrMIWLBdBEXzWdGEuStw8RyOa
         8aWIBaroR15rslgt9lWYCnhas9ZwE/5U67jo6qXd7Mu2V91jr4NJN4A4QnNXwxMVc7GT
         D2ONsoatV6cg45TOIjD/VlnVFGkYeG/uajFGg=
Message-ID: <38b2ab8a0808080123t5083dc17qa250bd02c753f80d@mail.gmail.com>
Date: Fri, 8 Aug 2008 10:23:45 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: question about do_anonymous_page()
In-Reply-To: <38b2ab8a0808080101v795327f0n9da5adb33a3c1a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0808080101v795327f0n9da5adb33a3c1a9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ resending with linux-mm address fixed, sorry ]

On Fri, Aug 8, 2008 at 10:01 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I'm wondering why do_anonymous_page() calls lru_cache_add_active(page)
> where page does not belong to the page cache ?
>
> Is it simply because lru_add_active() doesn't exist ?
>
> Thanks
> --
> Francis
>



-- 
Francis
