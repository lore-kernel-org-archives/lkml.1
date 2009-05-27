Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbZE0Hta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbZE0Hta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbZE0HtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:49:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45125 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbZE0HtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:49:20 -0400
Message-ID: <4A1CF0CF.9010602@redhat.com>
Date: Wed, 27 May 2009 15:50:39 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, rdunlap@xenotime.net, mingo@elte.hu
Subject: Re: [Patch 2/2] Doc: move Documentation/exception.txt into x86 subdir
References: <20090527072952.6279.72977.sendpatchset@localhost.localdomain> <20090527073001.6279.90725.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527073001.6279.90725.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> exception.txt only explains the code on x86, so it's better to
> move it into Documentation/x86 directory.
>
> This patch is on top of the previous one.
>   

Er, and also rename it to extable.txt which is more reasonable. :)

