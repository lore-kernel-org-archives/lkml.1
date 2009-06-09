Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZFIGVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZFIGVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZFIGVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:21:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZFIGVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:21:13 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 02:21:12 EDT
Date: Mon, 8 Jun 2009 23:15:23 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dan Carpenter <error27@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: smatch 1.53 released
In-Reply-To: <a63d67fe0906041250v6e4252c2g594322a3a49e7307@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0906082208430.6439@bogon>
References: <alpine.DEB.2.00.0906021141010.19390@bicker>  <87iqjedf2a.fsf@basil.nowhere.org> <a63d67fe0906041250v6e4252c2g594322a3a49e7307@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19Qlj7TvQcrHqgka3+DWwvZYR5EWUsAFhQA9+b
 aEQXzcQFm7D6FQe3A5VQdbSfLMF/3/OehjP54rVJgD0LkpKTbR
 H0IfAZGApiaekGW5NK61w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Dan Carpenter wrote:
>> Smatch is a source code checker for C.  Right now the focus is on checking
>> for kernel bugs.

Hm, smatch is pretty noisy. I'm getting hundreds of warnings and errors on 
a randconfig build: http://nerdbynature.de/bits/smatch/

False positives or real issues?

Thanks,
Christian.
-- 
BOFH excuse #182:

endothermal recalibration
