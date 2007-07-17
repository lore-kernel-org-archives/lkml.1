Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbXGQQAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbXGQQAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXGQQAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:00:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXGQQAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:00:44 -0400
Message-ID: <469CE79D.7030001@zytor.com>
Date: Tue, 17 Jul 2007 09:00:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] Use standard CR8 flags, and fix TPR definition
References: <1184677946.10380.4.camel@localhost.localdomain>	 <1184678060.10380.7.camel@localhost.localdomain>	 <1184678129.10380.10.camel@localhost.localdomain>	 <1184678171.10380.12.camel@localhost.localdomain>	 <1184678216.10380.14.camel@localhost.localdomain>	 <1184678275.10380.16.camel@localhost.localdomain>	 <1184678348.10380.19.camel@localhost.localdomain>	 <1184679175.10380.25.camel@localhost.localdomain>	 <1184679256.10380.27.camel@localhost.localdomain> <1184679437.10380.31.camel@localhost.localdomain>
In-Reply-To: <1184679437.10380.31.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Intel manual (and KVM definition) say it's TPR is 4 bits wide.  Also fix
> CR8_RESEVED_BITS typo.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Indeed it is.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
