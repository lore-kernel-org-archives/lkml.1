Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYC1Pne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYC1Pne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYC1Pn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:43:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45020 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752050AbYC1Pn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:43:26 -0400
Date: Fri, 28 Mar 2008 10:43:21 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: yhlu.kernel@gmail.com, ying.huang@intel.com, hpa@zytor.com,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64 boot -v2: Add linked listof struct
 setup_data to boot protocol
Message-Id: <20080328104321.105d3f6a.pj@sgi.com>
In-Reply-To: <20080328134413.GT29105@one.firstfloor.org>
References: <1206672578.13404.21.camel@caritas-dev.intel.com>
	<86802c440803272233ved9c1d6w44f8722c85cf4c62@mail.gmail.com>
	<20080328083613.f058172f.pj@sgi.com>
	<20080328134413.GT29105@one.firstfloor.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote:
> There are likely per node memory holes too, right?

Likely ... I don't have the details offhand.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
