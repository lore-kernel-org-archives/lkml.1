Return-Path: <linux-kernel-owner+w=401wt.eu-S1765595AbYEBPAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765595AbYEBPAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYEBPAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:00:46 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:40054 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYEBPAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=goZvenygxm9VZhHzPLLMeB94Eplnkzmz3QOruIKEaZeGazlhVp0lQjBy5Rvbigao8mj7hTAVkdnvW8UdKZuICi1JFbx10pRG5uA05z4J4xb8LvdgW5tqurJgwcout5POIkW9hQEiM3uoR1vGIP5BzKJ++V9jBmaRPzTH6dMS+uk=
Message-ID: <84144f020805020800w765c5248r6dba93240230b983@mail.gmail.com>
Date: Fri, 2 May 2008 18:00:43 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Cc: "David Woodhouse" <dwmw2@infradead.org>, "Tim Bird" <tim.bird@am.sony.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eduard-Gabriel Munteanu" <eduard.munteanu@linux360.ro>
In-Reply-To: <20080501104158.GM20451@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209577322.25560.402.camel@pmac.infradead.org>
	 <87bq3rgq40.fsf@basil.nowhere.org> <48190B5F.9010505@am.sony.com>
	 <20080501095822.GL20451@one.firstfloor.org>
	 <1209636171.25560.508.camel@pmac.infradead.org>
	 <20080501104158.GM20451@one.firstfloor.org>
X-Google-Sender-Auth: e2643dd9c07a93b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Thu, May 1, 2008 at 1:41 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > To a large extent, I agree. I certainly don't want to focus solely on
> > code size; there's a lot more to embedded Linux than that. But it _is_
>
>  Not only code size, far more important is dynamic memory consumption.
>  [admittedly we right now lack a good instrumentation framework for this]

There's a Google Summer of Code project going on now to implement such
instrumentation:

http://code.google.com/soc/2008/linux/appinfo.html?csaid=E749E676AD70FBB0

So any suggestions/input on this is obviously welcome.
