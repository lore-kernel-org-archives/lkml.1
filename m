Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYEEUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYEEUSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbYEEUSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:18:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:10179 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbYEEUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pJ8L5Xfb8Da1F8ajWYr8RgR451VVmxh4VRWXY+0eno/2cIBHFaEYz8+Jc0/I/Fd96VvJ9w0g2amEP6DddtNwPJ6HX94YLXIILx3aYfa+aU8E2hbJBUwA5rTNYv3Z3UyAhc3HL6ctLcg6OR6nbzpr3ql2DZ+gKE7iZZ741AyCp5U=
Message-ID: <2f11576a0805051318x32b3f2dej8b6f5af8e2d3f8c@mail.gmail.com>
Date: Tue, 6 May 2008 05:18:31 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] make mm/memory.c:print_bad_pte() static
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080505182700.GG17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182700.GG17139@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: e638ccb117cca2b7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch makes the needlessly global print_bad_pte() static.
>
>  Signed-off-by: Adrian Bunk <bunk@kernel.org>

             Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
