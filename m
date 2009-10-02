Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZJBHZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZJBHZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZJBHZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:25:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16726 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbZJBHZj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:1>);
	Fri, 2 Oct 2009 03:25:39 -0400
Message-Id: <4AC5C7130200007800017A42@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 02 Oct 2009 08:25:39 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Konrad Rzeszutek" <konrad@darnok.org>, <pjones@redhat.com>
Cc: "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
       "ketuzsezr@darnok.org" <ketuzsezr@darnok.org>,
       <alex.zeffertt@eu.citrix.com>,
       "Martin Wilck" <Martin.Wilck@ts.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iSCSI/iBFT: use proper address translation
References: <4AC47DED0200007800017743@vpn.id2.novell.com>
 <4AC5234C.5030409@citrix.com> <20091002012806.GB27478@andromeda.dapyr.net>
In-Reply-To: <20091002012806.GB27478@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Konrad Rzeszutek <konrad@darnok.org> 02.10.09 03:28 >>>
>The issue as I've come to understand is that the virt_to_phys on
>memory below the 1MB does not work. Alex suggested another fix which
>ioremap's the iBFT region, but I think this patch by Martin does the same job.
>
>Either way, it looks good to me.
>
>Signed-off-by: Konrad Rzeszutek Wilk <ketuzsezs@darnok.org>

With both ofyou having signed off on it - who's going to push this to
Linus? I'm specifically asking in case I'm expected to.

Jan

