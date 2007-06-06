Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXFFWoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXFFWoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964845AbXFFWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:43:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49616 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764852AbXFFWnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:43:50 -0400
Date: Wed, 6 Jun 2007 15:43:47 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: serue@us.ibm.com, menage@google.com, akpm@linux-foundation.org, dev@sw.ru,
       xemul@sw.ru, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-Id: <20070606154347.a155630b.pj@sgi.com>
In-Reply-To: <20070606223952.GB5626@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070604191412.GA901@sergelap.austin.ibm.com>
	<20070604123151.4db007a6.pj@sgi.com>
	<6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
	<20070604204131.GB19409@sergelap.austin.ibm.com>
	<20070604140533.65e25286.pj@sgi.com>
	<20070606223952.GB5626@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I wasn't paying close enough attention to understand why you couldn't
> > do it in two steps - make the container, and then populate it with
> > resources.
> 
> Sorry, please clarify - are you saying that now you do understand, or
> that I should explain?

Could you explain -- I still don't understand why you need this option.
I still don't understand why you can't do it in two steps - make the
container, then add cpu/mem separately.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
