Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYEBLh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYEBLh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYEBLhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:37:15 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:21611 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760581AbYEBLhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:37:14 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Horrendous Audio Stutter - current git
Date: Fri, 2 May 2008 13:37:10 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <1209724553.13978.143.camel@twins> <1209726499.13978.146.camel@twins>
In-Reply-To: <1209726499.13978.146.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021337.10809.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 11:37:11.0671 (UTC) FILETIME=[DC7AB070:01C8AC48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Peter Zijlstra wrote:
> > Ok, that's _WAY_ too big, something went seriously wrong. Thanks!
>
> In fact, that is exactly 1024 time too large.
>
> How does this work for you:

Changes nothing. Values of bonus_max are unchanged and still skips.
