Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYDHOx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYDHOx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYDHOxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:53:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30825 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbYDHOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:53:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mbwZSazYLLvSZNXLrCHeHzAppKegTP4A/Jlv9qoy+ohpxSDwb100NbTnicqYxYvIY
	eUplyOS6b1k0edWkp1vug==
Message-ID: <6599ad830804080753g39736d73yae5c47b6881e1d2d@mail.gmail.com>
Date: Tue, 8 Apr 2008 07:53:26 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] [0/2] Basic stats for cgroups V2
Cc: "Balaji Rao" <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       a.p.zijlstra@chello.nl, "Ingo Molnar" <mingo@elte.hu>,
       "Vivek Kashyap" <vivk@us.ibm.com>
In-Reply-To: <47FB4932.8040706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804052339.42474.balajirrao@gmail.com>
	 <6599ad830804080036h5496e3bdv9ac2dedf0f04f9bc@mail.gmail.com>
	 <47FB4932.8040706@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 3:30 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  > Thoughts?
>
>  I like the overall approach, do you have a prototype implementation?
>

No, nothing yet. Well, I posted a version of the API description file
a couple of months ago but people didn't seem to like that.

Paul
