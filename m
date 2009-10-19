Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbZJSRW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbZJSRW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbZJSRW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:22:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990AbZJSRW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:22:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Jan Beulich" <JBeulich@novell.com>
X-Fcc: ~/Mail/linus
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: fix register leak in 32-bit syscall audting
In-Reply-To: Jan Beulich's message of  Monday, 19 October 2009 12:52:02 +0100 <4ADC6F02020000780001AAB6@vpn.id2.novell.com>
References: <4ADC6F02020000780001AAB6@vpn.id2.novell.com>
X-Zippy-Says: I am a traffic light, and Alan Ginsberg kidnapped my laundry in 1927!
Message-Id: <20091019171947.04EE41E@magilla.sf.frob.com>
Date: Mon, 19 Oct 2009 10:19:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
