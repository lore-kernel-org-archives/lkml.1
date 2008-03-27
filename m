Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbYC0RQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbYC0RQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbYC0RQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:16:06 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:17907 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbYC0RQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=U6JfMKBv786nrddy0zIgfK1zAkt8zfAWWrbw/08DriEm0QtK2cmRmCtBmeQCup305PJ6gwd6WcwHGgta3L+/z1MjL85HkzKT+VtvUf0pWYPgqWsh3ap3ihDAJih+fDIDL4TX0u9i1sIbU0lQdTfQA0STXtFW6qWWvOx38I5eNuw=
Message-ID: <2f11576a0803271016x3758563fq1a90a3677e156ae1@mail.gmail.com>
Date: Fri, 28 Mar 2008 02:16:03 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.25: something wrong with ^C
Cc: "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080327142814.GC13190@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080327142814.GC13190@elf.ucw.cz>
X-Google-Sender-Auth: d639cc842b20a33b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  Is it just me, or does ^C take longer in 2.6.25?
>
>  Like... one second delay between pressing ^C and seeing any effect?
>                                                                         Pavel

I can't reproduce it.
