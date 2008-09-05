Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYIEGn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYIEGn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 02:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYIEGnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 02:43:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:53159 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYIEGnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 02:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lhGeI49HCnGKd0qYziGYm+MpIde0VQyrDYNkONsopsS1MEmr4lvrqvaQAvg4MM+KQs
         cQJZ9t9xFFnz5Q54Iihj1xQdG2PuhAUD17Pa9PAE7geZaFhSM6L2BWEQ1WBwCk2leAXB
         wtbTCt7S7/pFUimo/YMqJJXrXbmRClwL4MJ0Q=
Message-ID: <48C0E383.5060308@gmail.com>
Date: Fri, 05 Sep 2008 11:15:07 +0330
From: "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com>
Reply-To: hamid.jahanjou@gmail.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
References: <48BFCECE.90103@gmail.com> <20080904161433.5b020bd9.akpm@linux-foundation.org>
In-Reply-To: <20080904161433.5b020bd9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I tried that once.  The code all worked as-designed but didn't seem to
> improve performance much across a spread of workloads.
>
> Benchmarks are essential, please.  Good ones.
Do you recommend any specific benchmarks for memory-related projects ?
Which
one did you use for your own implementation ?

Thank You
