Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXHAIb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXHAIb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759016AbXHAIbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:31:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758992AbXHAIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:31:13 -0400
Date: Wed, 1 Aug 2007 01:30:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
 (vm-dont-run-touch_buffer-during-buffercache-lookups.patch)
Message-Id: <20070801013055.5662c498.akpm@linux-foundation.org>
In-Reply-To: <1185955446.7393.11.camel@perkele>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<1185953790.6393.20.camel@perkele>
	<20070801004625.46a24a26.akpm@linux-foundation.org>
	<1185955446.7393.11.camel@perkele>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 04:04:06 -0400 Eric St-Laurent <ericstl34@sympatico.ca> wrote:

> I intend to try only this specific patch not the full -mm, is there any
> other patch I need to apply too?
> 

no, it is standalone.
