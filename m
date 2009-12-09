Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZLIUsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZLIUsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbZLIUsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:48:03 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48385 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757514AbZLIUsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:48:01 -0500
X-Sasl-enc: bruPsgKcr7sBN8KYP0Ymgdf0dss2ss/3/TDRqUuFfkIC 1260391687
Date: Wed, 9 Dec 2009 18:48:03 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Norbert Preining <preining@logic.at>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Sven-Haegar Koch <haegar@sdinet.de>, Dave Chinner <david@fromorbit.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
Message-ID: <20091209204803.GD29575@khazad-dum.debian.net>
References: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com>
 <2f11576a0911190636vd21069bv2fe4f22a57b3d333@mail.gmail.com>
 <c0c067900911251513v48a34b18k73fb48f0e8d43c30@mail.gmail.com>
 <4B0DDFDA.1030905@redhat.com>
 <c0c067900912022016u32e393cw3fe9e04ba1051253@mail.gmail.com>
 <c0c067900912071249y68c4c2bby90202bd5f467ea2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0c067900912071249y68c4c2bby90202bd5f467ea2c@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009, Dan Merillat wrote:
> >> Can you try out the patch from
> >> http://lkml.org/lkml/2009/11/25/467 ?
> 
> After a week of testing, that seems to have been the issue, thanks!

In that case, is that patch being considered for stable@ ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
