Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbXCFJPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbXCFJPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934007AbXCFJPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:15:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58912 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173AbXCFJP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:15:27 -0500
Date: Tue, 6 Mar 2007 01:15:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.A. =?ISO-8859-1?B?TWFnYWxs824i?= <jamagallon@ono.com>"@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-Id: <20070306011524.b0945a42.akpm@linux-foundation.org>
In-Reply-To: <20070306100623.770b9dc9@werewolf-wl>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070306100623.770b9dc9@werewolf-wl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 10:06:23 +0100 "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Tue, 6 Mar 2007 00:44:08 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> > 
> 
> Does this include a fix for the NFS problem ?

Which NFS problem?

> BTW, I have in my kernel a patch like this below, isn't it needed ?
> Original thread:
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117189051227292&w=2

That patch caused additional failures.  But I tossed out the git-block tree,
so that problem should no longer be there.

