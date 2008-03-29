Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYC2GUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYC2GUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 02:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYC2GUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 02:20:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51485 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750854AbYC2GUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 02:20:11 -0400
Date: Sat, 29 Mar 2008 01:20:03 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/4] x86_64 boot: Add linked list of struct
 setup_data
Message-Id: <20080329012003.54172e04.pj@sgi.com>
In-Reply-To: <1206670117.13404.6.camel@caritas-dev.intel.com>
References: <1206601748.3067.22.camel@caritas-dev.intel.com>
	<20080327062539.5cbcb925.pj@sgi.com>
	<1206670117.13404.6.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> This break will break the switch instead of while.

Right you are ... sorry for my confusion.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
