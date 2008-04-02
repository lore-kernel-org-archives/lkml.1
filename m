Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYDBHkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYDBHkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYDBHjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:39:54 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36981 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751689AbYDBHjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:39:53 -0400
Date: Wed, 2 Apr 2008 02:39:47 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86_64 boot -v2: Add linked list of struct
 setup_data
Message-Id: <20080402023947.d4d43f7d.pj@sgi.com>
In-Reply-To: <1206924877.21451.6.camel@caritas-dev.intel.com>
References: <1206672584.13404.25.camel@caritas-dev.intel.com>
	<20080329233155.ee909a04.pj@sgi.com>
	<1206924877.21451.6.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> On Sat, 2008-03-29 at 23:31 -0500, Paul Jackson wrote:
> > Huang wrote:
> > > +/* setup data types */
> > > +#define SETUP_NONE			0
> > 
> > This define seems unused?
> 
> I think this can prevent somebody to use 0 as type id.

Why is it a good idea to prevent a 0 type id?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
