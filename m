Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYCTHnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYCTHnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYCTHnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:43:24 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:34791 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYCTHnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Gdwjxy0OVEtKkcKxhycIFToa7mBnG5Z5uganqfvDbdekuCPXc5Zy4jWqRQ4qCdQaZ+g5rGBYYSewrximOONEsDJkdA3KOE5dgPLgjrAqk32idFPFijEv2ti+iXHREyy1xbz77vuGeD0VQb5Vi3hJ8S1PvoO9U0n0eZrfNndh6KM=
Message-ID: <2f11576a0803200043p52d875ealcebe46d47d539628@mail.gmail.com>
Date: Thu, 20 Mar 2008 16:43:22 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [0/2] vmalloc: Add /proc/vmallocinfo to display mappings
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080319150704.d3f090e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318222701.788442216@sgi.com>
	 <20080319111943.0E1B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080319150704.d3f090e6.akpm@linux-foundation.org>
X-Google-Sender-Auth: 9a1d5d08d8bd8cbc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

>  > > Example:
>  > >
>  > > cat /proc/vmallocinfo
>
>  argh, please don't top-post.
>
>  (undoes it)

sorry, I don't do that at next.

>  > Great.
>  > it seems very useful.
>  > and, I found no bug.
>  >
>  > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
>  I was just about to ask whether we actually need the feature - I don't
>  recall ever having needed it, nor do I recall seeing anyone else need it.
>
>  Why is it useful?

to be honest, I tought this is merely good debug feature.
but crishtoph-san already explained it is more useful things.

Thanks.
