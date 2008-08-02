Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYHBIi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYHBIi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 04:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYHBIiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 04:38:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33420 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYHBIiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 04:38:21 -0400
Message-ID: <48941C2F.8010406@cs.helsinki.fi>
Date: Sat, 02 Aug 2008 11:34:55 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
References: <20080801000405.GA7072@martell.zuzino.mipt.ru>
In-Reply-To: <20080801000405.GA7072@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Right now, SYSFS=n means no SLUB debugging, no even basic poisoning,
> to hell with tunables.

Applied, thanks!
