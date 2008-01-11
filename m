Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbYAKJTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbYAKJTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbYAKJTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:19:04 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38404 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYAKJTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:19:03 -0500
Subject: Re: [PATCH] checkpatch.pl: allow piping
From: Daniel Walker <dwalker@mvista.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: apw@shadowen.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <47872E35.3070705@gmail.com>
References: <20080111041120.085610726@mvista.com>
	 <47872E35.3070705@gmail.com>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 01:17:15 -0800
Message-Id: <1200043035.29897.62.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 09:52 +0100, Jiri Slaby wrote:
> On 01/11/2008 05:10 AM, Daniel Walker wrote:
> > A little feature addition to allow checkpatch.pl to check patches piped
> > into it, in addition to specific file arguments.
> 
> You can still add - as an argument to check stdin. In which way is this better?

There's was no reason to limit the arguments ..

I was using it to do something like the following ,

git show 9914cad54c79d0b89b1f066c0894f00e1344131c | ./scripts/checkpatch.pl

Which I think is useful .

Dainel

