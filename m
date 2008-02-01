Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYBAOtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYBAOtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYBAOt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:49:26 -0500
Received: from saeurebad.de ([85.214.36.134]:51786 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbYBAOtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:49:25 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
References: <20080201104718.GA11717@uranus.ravnborg.org>
	<20080201030329.9b760777.akpm@linux-foundation.org>
Date: Fri, 01 Feb 2008 15:48:43 +0100
In-Reply-To: <20080201030329.9b760777.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 1 Feb 2008 03:03:29 -0800")
Message-ID: <87y7a4wx4k.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton <akpm@linux-foundation.org> writes:

> Question is: why do people keep adding new ones when they are so easy to
> detect and fix?
>
> Asnwer: because neither they nor their patch integrators are doing adequate
> compilation testing.

How about adding an Untested-by tag for psychological reasons?

	Hannes
