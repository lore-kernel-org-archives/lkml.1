Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbZJPOwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbZJPOwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 10:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbZJPOwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 10:52:16 -0400
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:53852 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932611AbZJPOwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 10:52:16 -0400
Message-ID: <4AD88854.20807@agilent.com>
Date: Fri, 16 Oct 2009 07:51:00 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs/pipe.c null pointer dereference
References: <4AD5D476.6010103@agilent.com>	 <200910141653.03611.elendil@planet.nl> <4AD655C0.2030202@agilent.com>	 <200910150211.43532.elendil@planet.nl> <4AD7F633.4070507@agilent.com> <84144f020910160016r125e2cbrf2fae48f168db79c@mail.gmail.com>
In-Reply-To: <84144f020910160016r125e2cbrf2fae48f168db79c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 14:51:04.0124 (UTC) FILETIME=[15B927C0:01CA4E70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Can you please send the patch to LKML so your fix doesn't get lost in
> the noise? See Documentation/SubmittingPatches for details.

Done.

http://lkml.org/lkml/2009/10/16/146

Earl



