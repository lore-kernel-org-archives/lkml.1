Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYAXXF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYAXXF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYAXXFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:05:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYAXXFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:05:15 -0500
Message-ID: <47991989.8060205@zytor.com>
Date: Thu, 24 Jan 2008 15:04:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca> <20080124125845.bf5767b8.randy.dunlap@oracle.com> <20080124210431.GA1647@Krystal>
In-Reply-To: <20080124210431.GA1647@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Try opening such code in vim, and the syntax highlighting gets all
> messed up :-/
> 
> The other option is to do the *right thing* and fix vim, of course, but
> this change won't be in distros for a while.
> 

Let's get this straight...

You're suggesting introducing a pointless, ugly macro into the kernel 
because of a vim bug?

*Plonk!*

	-hpa
