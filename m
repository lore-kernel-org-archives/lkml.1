Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbYC2GYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbYC2GYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 02:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYC2GY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 02:24:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51562 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbYC2GY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 02:24:27 -0400
Date: Sat, 29 Mar 2008 01:24:23 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/4] x86_64 boot: Add linked list of struct
 setup_data
Message-Id: <20080329012423.0c1d693e.pj@sgi.com>
In-Reply-To: <1206670181.13404.7.camel@caritas-dev.intel.com>
References: <1206601748.3067.22.camel@caritas-dev.intel.com>
	<20080327063307.ac323913.pj@sgi.com>
	<1206670181.13404.7.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> The setup_data will not only be used for E820 extension.

I'm still unsure of your meaning.

Are you saying that 'setup_data' is not used in your current patch set?

Are you also saying that 'setup_data' will be used in the future?

>  So a type field is used to distinguish various setup_data.

What various types of 'setup_data' will be distinguished?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
