Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZGAPPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZGAPPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZGAPP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:15:26 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43587 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbZGAPPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:15:24 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 1 Jul 2009 08:14:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Jiri Olsa <jolsa@redhat.com>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCHv3 1/2] net: adding memory barrier to the poll and receive
 callbacks
In-Reply-To: <20090701080946.GB4769@jolsa.lab.eng.brq.redhat.com>
Message-ID: <alpine.DEB.1.10.0907010812110.10303@makko.or.mcafeemobile.com>
References: <20090630125240.GB4406@jolsa.lab.eng.brq.redhat.com> <20090630125425.GC4406@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.1.10.0906301210210.3968@makko.or.mcafeemobile.com> <20090701065724.GA2852@jolsa.lab.eng.brq.redhat.com>
 <alpine.DEB.1.10.0907010002010.8492@makko.or.mcafeemobile.com> <20090701073001.GA4769@jolsa.lab.eng.brq.redhat.com> <20090701080946.GB4769@jolsa.lab.eng.brq.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Jiri Olsa wrote:

> ok, how about this

Looks good. maybe you can remove things like "The fix is generic for other 
protocols as well", that are more fot for the email body patch 
description.


- Davide


