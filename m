Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYAXXEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYAXXEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYAXXD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:03:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44936 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYAXXD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:03:56 -0500
Message-ID: <47991940.3060206@zytor.com>
Date: Thu, 24 Jan 2008 15:03:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca>
In-Reply-To: <20080124203335.082459062@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Add initialization of an array, which needs brackets that would pollute kernel
> code, to kernel.h

"brackets which would pollute kernel code"???

	-hpa
