Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZK3Xu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZK3Xu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZK3Xu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:50:27 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:14476 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZK3Xu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:50:26 -0500
Subject: Re: Block IO Controller V4
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com
In-Reply-To: <20091130225640.GO11670@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com>
	 <20091130160024.GD11670@redhat.com>
	 <4e5e476b0911301334o2440ea8fi7444aa7d5a688ed1@mail.gmail.com>
	 <1259618433.2701.31.camel@cail>  <20091130225640.GO11670@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 18:50:25 -0500
Message-ID: <1259625025.2701.33.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 17:56 -0500, Vivek Goyal wrote:
> On Mon, Nov 30, 2009 at 05:00:33PM -0500, Alan D. Brunelle wrote:
> > FYI: Results today from my test suite - haven't had time to parse them
> > in any depth...
> 
> Thanks Alan. I am trying to parse the results below. s0 and s8 still mean
> slice idle enabled disabled? Instead of that we can try group_isolation
> enabled or disabled for all the tests.

I'm concerned as well - I think I did the base run /after/ the i1,s0
run. I'll need to check that out tomorrow...

Alan


