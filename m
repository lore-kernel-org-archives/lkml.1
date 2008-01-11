Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbYAKJtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbYAKJtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYAKJtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:49:46 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:45833 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYAKJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:49:45 -0500
Subject: Re: [PATCH] checkpatch.pl: allow piping
From: Daniel Walker <dwalker@mvista.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bernd Petrovitsch <bernd@firmix.at>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <478739AD.3000005@gmail.com>
References: <20080111041120.085610726@mvista.com>
	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>
	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>
	 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com>
	 <1200044206.29897.73.camel@imap.mvista.com>  <478739AD.3000005@gmail.com>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 01:47:58 -0800
Message-Id: <1200044878.29897.78.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 10:41 +0100, Jiri Slaby wrote:
> On 01/11/2008 10:36 AM, Daniel Walker wrote:
> > On Fri, 2008-01-11 at 10:34 +0100, Jiri Slaby wrote:
> >> If somebody is hacking kernel, I think he should know the - trick used in many 
> >> programs, but do not consider this as a nack.
> > 
> > I'm hacking the kernel, and I didn't know the - trick .. So you have
> > your testing case all in one with the patch submitter ..
> 
> OK, maybe we should base it in doc for patch submitting then?

It's in the bash docs I'm sure, it's just a matter of who ends up
reading that part of the docs.. I still think my patch is a good one ,
we could change the name to "Allow piping with out tricks" I suppose ..

Daniel

