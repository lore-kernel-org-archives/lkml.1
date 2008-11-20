Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYKTRy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYKTRy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYKTRyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:54:20 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48524 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbYKTRyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:54:19 -0500
Subject: Re: [PATCH 2.6.28-rc5 00/11] Kernel memory leak detector (updated)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081120121016.GE20724@elte.hu>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120121016.GE20724@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 20 Nov 2008 17:54:06 +0000
Message-Id: <1227203646.14146.49.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 17:54:08.0074 (UTC) FILETIME=[FC596AA0:01C94B38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 13:10 +0100, Ingo Molnar wrote:
> got a couple of build errors and warnings on x86 with the attached 
> config:

Thanks. I haven't got any of these on ARM but the headers were probably
included via other headers. I'll give it a try with your .config.

-- 
Catalin

