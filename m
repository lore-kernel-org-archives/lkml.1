Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbXGJHfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbXGJHfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXGJHfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:35:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbXGJHfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:35:01 -0400
Date: Tue, 10 Jul 2007 00:34:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 1/16] Round up the API
Message-Id: <20070710003450.d88ddaa6.akpm@linux-foundation.org>
In-Reply-To: <469329CD.1040505@openvz.org>
References: <468DF6F7.1010906@openvz.org>
	<468DF745.6070705@openvz.org>
	<46929819.3030205@fr.ibm.com>
	<469329CD.1040505@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 10:40:13 +0400 Pavel Emelianov <xemul@openvz.org> wrote:

> > I think we are all ok with it. right ?
> 
> Right. That's already the 3rd time I send it to Andrew...

I'm basically ignoring all the containers/resource-control stuff, waiting
for it to appear to have settled down.  It's quite unclear which patches
are at the RFC stage and which are at the ready-to-go stage.

If you guys could gather and maintain the acked-by's and make it clear what
the maturity level is on each patch series it would help, thanks.

