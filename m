Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbYGRXSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbYGRXSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761127AbYGRXSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:18:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48677 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761100AbYGRXSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:18:39 -0400
Message-ID: <488124BC.3070600@zytor.com>
Date: Fri, 18 Jul 2008 16:18:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: reduce boot fixmap space
References: <4880A8AC.76E4.0078.0@novell.com>
In-Reply-To: <4880A8AC.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> As 256 entries are needed, aligning to a 256-entry boundary is
> sufficient and still guarantees the single pte table requirement.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Manually applied to x86/fixmap, thanks.

	-hpa
