Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYJCSHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYJCSHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYJCSH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 14:07:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:28892 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJCSH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 14:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CQHmMV6UT04SvkSRlcoUALsigvFnrkAdldrnmGrZhZyZ2tUafjbn7dg3WS7Fvj+IYQ
         tZ1q+N++YwLcCrWn9Oxla0S8Kurz090SLrX6ER70pXOiqjb8F8HmnAcsNhcB1V6MYiCe
         XYgeYU7nwPctTEkzTjjeGtL+wD6u9OEuFbIi4=
Message-ID: <c62985530810031107j72f3d435lf8a372b8a583e4b4@mail.gmail.com>
Date: Fri, 3 Oct 2008 19:07:22 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alan Jenkins" <aj504@student.cs.york.ac.uk>
Subject: Re: [PATCH -tip] Tracing/fastboot: Only trace non-module initcalls
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <c62985530810031059v5ed44e04qebaf9453710e76c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E62089.7050006@gmail.com> <48E659CB.5030902@tuffmail.co.uk>
	 <c62985530810031059v5ed44e04qebaf9453710e76c1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2008/10/3 Alan Jenkins <aj504@student.cs.york.ac.uk>:
>It would be nice to see the "before" svg as well as the "after", to explain the change.

(Sorry, didn't see that line...)

I have to go, but when I will have more time, I will show you the difference....
