Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbYKGWRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbYKGWRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKGWQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:16:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:62524 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYKGWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:16:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XvFz8RnQ+bnRI0IuO/ThmwdQAagsDKWSCYMoEJb/d22EoVhhKQzCRdNKhFFtWClJRu
         TpHvoJ/Ypj5OH9sf9c6Fs2OO46Yv1CikudtGwIuqPve32Lh5ZKkCkwRZNjiX3mX2ynbB
         +ujbWirnhP8HdyJhfpgwFcSZSzyDkLaRONQbI=
Date: Sat, 8 Nov 2008 01:20:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] DOC: add printk-formats.txt
Message-ID: <20081107222015.GA6549@x200.localdomain>
References: <20081107135132.a6fe9bba.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107135132.a6fe9bba.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 01:51:32PM -0800, Randy Dunlap wrote:
> Add printk-formats.txt so that we don't have to keep fixing the
> same things over and over again.  <wishful thinking>

Pity we can't put a copy of C99 in tree. :-)
