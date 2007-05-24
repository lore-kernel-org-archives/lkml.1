Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXEXHjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXEXHjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbXEXHjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:39:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30291 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbXEXHjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:39:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=KxCXxGax6k5O1y88RDNQcyEQyyJGlgr62M/cge0+VyVxhjYXtiQ1a7JwvHF3d432N
	SuEFr1iMoQJB+qV/6mxGA==
Message-ID: <6599ad830705240039p10574207maca62b8c44825db7@mail.gmail.com>
Date: Thu, 24 May 2007 00:39:21 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: RSS controller v2 Test results (lmbench )
Cc: "Kirill Korotaev" <dev@sw.ru>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@sw.ru>, devel@openvz.org,
       "Linux Containers" <containers@lists.osdl.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Herbert Poetzl" <herbert@13thfloor.at>
In-Reply-To: <4655407A.4090104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464C95D4.7070806@linux.vnet.ibm.com>
	 <20070517112357.7adc4763.akpm@linux-foundation.org>
	 <4651B4BF.9040608@sw.ru> <4655407A.4090104@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Kirill Korotaev wrote:
> >> Where do we stand on all of this now anyway?  I was thinking of getting Paul's
> >> changes into -mm soon, see what sort of calamities that brings about.
> > I think we can merge Paul's patches with *interfaces* and then switch to
> > developing/reviewing/commiting resource subsytems.
> > RSS control had good feedback so far from a number of people
> > and is a first candidate imho.
> >
>
> Yes, I completely agree!
>

I'm just finishing up the latest version of my container patches -
hopefully sending them out tomorrow.

Paul
