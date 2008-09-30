Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYI3SsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYI3SsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYI3SsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:48:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27529 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYI3SsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:48:07 -0400
Date: Tue, 30 Sep 2008 11:36:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Rubini <ar@gnudd.com>,
       Alessandro Rubini <rubini@vision.unipv.it>
Subject: Re: About the maintainer of "MOUSE AND MISC DEVICES"
Message-Id: <20080930113647.5aee57ec.randy.dunlap@oracle.com>
In-Reply-To: <20080930153708.GX18732@tekkaman>
References: <20080930153708.GX18732@tekkaman>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 17:37:08 +0200 Rodolfo Giometti wrote:

> Hello,
> 
> I just wrote to Alessandro in order to have some suggestions about a
> misc device I wish to propose to this list, but he told me that he
> wants leave his maintanership.
> 
> So which is the person should I send my requests about misc devices?
> 
> He also asked to me to propose to this list a "patch" to remove him
> from the MAINTANERS file... if so the new entry should be:
> 
> MOUSE AND MISC DEVICES [GENERAL]
> L:      linux-kernel@vger.kernel.org
> S:      Maintained
> 
> Is taht correct?

I'd say that the entry should just be for MISC DEVICES.
MOUSE is covered/handled by INPUT DRIVERS.

The L: and S: look OK to me.

Please send a patch to linux-kernel@vger.kernel.org and
to akpm@linux-foundation.org .

Thanks,
---
~Randy
