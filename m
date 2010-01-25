Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506Ab0AYNwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0AYNwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165Ab0AYNwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:52:37 -0500
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:60802 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915Ab0AYNwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:52:36 -0500
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Warnings about tasks on CPU 1 during STR
Date: Mon, 25 Jan 2010 14:52:33 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201001250542.08642.elendil@planet.nl> <1264423859.4283.1725.camel@laptop>
In-Reply-To: <1264423859.4283.1725.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001251452.34237.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jan 2010 13:52:35.0228 (UTC) FILETIME=[A5FADDC0:01CA9DC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Peter Zijlstra wrote:
> On Mon, 2010-01-25 at 05:42 +0100, Frans Pop wrote:
> > All the "Task X is on cpu 1" messages (76 in total) are new. Bug or
> > intentional? As it is a warning, I suspect a bug.
>
> http://lkml.org/lkml/2010/1/21/175

Thanks Peter, that fixes it.

I've a small cleanup patch for the warning that I'll send separately.

Cheers,
FJP
