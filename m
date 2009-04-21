Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZDUDA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZDUDA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZDUDAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:00:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35331 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDUDAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RL66zPMUyd8bfdt/87Hr1+Xoot69Wt0yZgS8FpVUG+8xeqosFBRfj+FlmPMrXcf+1i
         DxEVZrO/MDvVXoZtmkOCknWP8Df7SI/ZTAzyaX5fzV7YCpH2uCE4MHXgRPeBocCtTHA3
         ba4OV6o6MX1vHF75uWGz9en25S72hOLJJ6j7M=
MIME-Version: 1.0
In-Reply-To: <b239d23646a4054d65c791ca7118c1d1.squirrel@webmail-b.css.fujitsu.com>
References: <20090416120316.GG7082@balbir.in.ibm.com>
	 <20090417110350.3144183d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090417034539.GD18558@balbir.in.ibm.com>
	 <20090417124951.a8472c86.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090417045623.GA3896@balbir.in.ibm.com>
	 <20090417141726.a69ebdcc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090417064726.GB3896@balbir.in.ibm.com>
	 <20090417155608.eeed1f02.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090417141837.GD3896@balbir.in.ibm.com>
	 <b239d23646a4054d65c791ca7118c1d1.squirrel@webmail-b.css.fujitsu.com>
Date: Tue, 21 Apr 2009 08:30:08 +0530
X-Google-Sender-Auth: f1a05d9bc5eb57d5
Message-ID: <661de9470904202000w3e879ed6l12b08448a0c4255c@mail.gmail.com>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource 
	controller (v3)
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/17 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
[snip]
> ok, let's start testing under -mm.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Nice feature :)
>

Hi, Andrew,

Could you please pick this up for testing under -mm.

Thanks,
Balbir
