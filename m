Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZLWMEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZLWMEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZLWMEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:04:45 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:36798 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZLWMEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:04:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Fmz1sHFa5YF1fuwH3yCO+da+LK2RVtkEn18YFWLGtvECb/dT1spDN+hwJ96MLZ06RT
         zjOvIDEocxd05A7+hUScnBArHD5J/+Pu10Y/3vc816PNuEM30pIg3TQCV1BDBvx8xVgO
         ewFFxRWrhio/KO30IITRxOVmbvBK3y6qiJ9f0=
MIME-Version: 1.0
In-Reply-To: <1261569112.4937.135.camel@laptop>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
	 <1261563687.4937.120.camel@laptop>
	 <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
	 <1261565584.4937.124.camel@laptop>
	 <b9df5fa10912230335r459f86d4te868fca82b891752@mail.gmail.com>
	 <1261569112.4937.135.camel@laptop>
Date: Wed, 23 Dec 2009 18:04:44 +0600
Message-ID: <b9df5fa10912230404p37edca22h54ef7dceec651de4@mail.gmail.com>
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-12-23 at 17:35 +0600, Rakib Mullick wrote:

>  Do you have a particular workload you worry about or are you merely
>  trying to satisfy your curiosity?
>
No, I don't have any particular workload.
>
>
