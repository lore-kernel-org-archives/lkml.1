Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZBJH2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZBJH2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 02:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZBJH2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 02:28:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37736 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZBJH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 02:28:23 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Cc: kosaki.motohiro@jp.fujitsu.com, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <19f34abd0902092310g513fb776s2e4d37285c8fa7be@mail.gmail.com>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <19f34abd0902092310g513fb776s2e4d37285c8fa7be@mail.gmail.com>
Message-Id: <20090210162708.6FBF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 16:28:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 10, 2009 at 6:41 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hi
> >
> > I periodically test kernel on stress workload.
> > Unfortunately, recent kerenel don't survive >24H.
> >
> > It paniced with following stack.
> > Do you have any suggestions?
> >
> > thanks!
> 
> That stack trace looks somewhat similar to the one in
> http://lkml.org/lkml/2009/2/6/136
> 
> If this is reproducible, maybe a patch like the one attached can help
> pinpoint it?

Thanks. I'll try it.
please wait one night, it need to reproduce.




