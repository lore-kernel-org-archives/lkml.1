Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYESLmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYESLmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 07:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYESLmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 07:42:38 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:23489 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbYESLmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 07:42:38 -0400
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: [PATCH 0/7] gcov kernel support
From: Andi Kleen <andi@firstfloor.org>
References: <48313D8E.7020109@de.ibm.com>
Date: Mon, 19 May 2008 13:42:16 +0200
In-Reply-To: <48313D8E.7020109@de.ibm.com> (Peter Oberparleiter's message of "Mon, 19 May 2008 10:42:54 +0200")
Message-ID: <87tzgubjvr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 May 2008 11:35:13.0960 (UTC) FILETIME=[67572A80:01C8B9A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Oberparleiter <peter.oberparleiter@de.ibm.com> writes:

> This is version #2 of the gcov kernel support patch set (see further
> below for an in-depth explanation). Patch base is 2.6.26-rc3.

I reviewed the patches and they look good to me (except for
some minor nits, probably not worth fixing)

-Andi
