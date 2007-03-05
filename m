Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbXCESVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbXCESVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXCESVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:21:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:60088 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbXCESU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:20:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fYwxuSe+CfLULA3G3iThPs/Da6kQLGWpXpI8eC+5ucq5ikX0dCMT2W5UyIco1QijEyyAm0qyhCtpgXc/3w55Csj0X3eewyo+tEpUlSrsdHYZfQYEp/+cYLtR8/T89ZnKUEaMbJGSbgv49mAGZTpnlGBjDlESfXyjGo8NHhsscjk=
Message-ID: <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com>
Date: Mon, 5 Mar 2007 13:20:56 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Cc: linux-kernel@vger.kernel.org,
       "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
In-Reply-To: <200703050453.08154.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
	 <200703050453.08154.gene.heskett@gmail.com>
X-Google-Sender-Auth: cde5643f223106fe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Monday 05 March 2007, Nicolas Mailhot wrote:
> >This looks like -mm stuff if you want it in 2.6.22
>
> This needs to get to 2.6.21, it really is that big an improvement.

You can probably speed things up by regression testing against a wide
range of non-desktop workloads and posting your numbers...

Lee
