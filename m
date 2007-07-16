Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbXGPJBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbXGPJBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXGPJBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:01:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:27163 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXGPJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OjhHSe+Ko3Nqp+cEq/w/9AJbbC7MgD1JC1iOpQ72UYtIwy6hPWVBXZa1pHSYkr065yD5qpYD7TLOTSjPqnEtbdyKeTGTElfqYIDLjzLYlzNxLxCxqBL5W6R6T3CEUaR6u3z+YcyehMf8e5hrYtFz5hHNwMducxWOONQaewQoMlU=
Message-ID: <a9e22dff0707160201y3b49223n425474a5fcf8eeb6@mail.gmail.com>
Date: Mon, 16 Jul 2007 12:01:06 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Fwd: performance -cfs19 vs. -ck1 for 2.6.22
In-Reply-To: <a9e22dff0707160200q7e266f1bw92cad569bf84b401@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707160112pc3b7bfcmc73adbd4edec670e@mail.gmail.com>
	 <20070716082917.GA1325@elte.hu>
	 <a9e22dff0707160138v109e2080u96726906ccb8b716@mail.gmail.com>
	 <20070716085545.GA5964@elte.hu>
	 <a9e22dff0707160200q7e266f1bw92cad569bf84b401@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> to help us figure out the nature of the delay, could you do another
> thing as well:
>
>   strace -ttt -TTT -f -o firefox.trace.txt -p `pidof firefox-bin`
>

I'll do that!!
