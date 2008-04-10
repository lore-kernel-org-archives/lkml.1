Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbYDJPDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbYDJPDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYDJPDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:03:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57964 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756901AbYDJPDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:03:09 -0400
Date: Thu, 10 Apr 2008 10:03:03 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: bert.wesarg@googlemail.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Message-Id: <20080410100303.340348ca.pj@sgi.com>
In-Reply-To: <47FBDB82.9000607@sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<36ca99e90804081233x2daef177u52a169d5382094df@mail.gmail.com>
	<47FBDB82.9000607@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
> I agree though sometimes "acceptance" is the hardest part... ;-)

For changes that would have changed several kernel interfaces
incompatibly, the bar of acceptance should be higher than for
changes that only affect kernel internals.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
