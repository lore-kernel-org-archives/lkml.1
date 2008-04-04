Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYDDFyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYDDFyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 01:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYDDFyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 01:54:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:3409 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYDDFya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 01:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sEzN4SnxxSQQP/rs40opX3XyrMNkMgTa4qIXswmBKQg+IkukFt3waIIDTDqWAEOFP0bbw1CxlN03SIn/6gZ85bMxMLX3R3Xz1i9zxAslN8T0zBOyeCRj3UI2YA/VcKNH6gYtg2cddy7Y3Y035zSZ9X/jEsREoiqv1SyifVen5JU=
Message-ID: <15ddcffd0804032254t4533d41br671edf335c6daabb@mail.gmail.com>
Date: Fri, 4 Apr 2008 08:54:29 +0300
From: "Or Gerlitz" <or.gerlitz@gmail.com>
To: "Tziporet Koren" <tziporet@dev.mellanox.co.il>
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's in infiniband.git)
Cc: "Roland Dreier" <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, "Dror Goldenberg" <gdror@mellanox.co.il>
In-Reply-To: <47F37CA4.8000109@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adave31bayd.fsf@cisco.com> <47F37CA4.8000109@mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 3:31 PM, Tziporet Koren
<tziporet@dev.mellanox.co.il> wrote:

>  We want to add send with invalidate
>  Eli will be able to send the patches next week and since they are small I think they can be in for 2.6.26

Does send with invalidate applies to rkeys generated through the
proprietary FMR API?
if not, what usage you envision to the new verb under nowadays IB devices?

Or.
