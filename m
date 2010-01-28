Return-Path: <linux-kernel-owner+w=401wt.eu-S932256Ab0A1Kwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab0A1Kwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201Ab0A1Kwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:52:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:33726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab0A1Kwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:52:54 -0500
Subject: Re: [PATCH/RFC v2 0/3] Human readable platform-specific
 performance event support
From: Peter Zijlstra <peterz@infradead.org>
To: Tomasz Fujak <t.fujak@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, p.osciak@samsung.com,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com,
       m.nazarewicz@samsung.com
In-Reply-To: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
References: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 11:52:14 +0100
Message-ID: <1264675934.4283.2088.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 10:34 +0100, Tomasz Fujak wrote:
> Human readable description support for performance events v2. With perf support included.
> Changes from v1:
>  - applied on top of latest perf_event/ARM (5899/1 - 5903/1)
>  - moved to debugfs, now based on seq_file
>  - reads one line at a time, memory overallocation fixed [perf]

You can keep sending these patches, but I'll keep ignoring them
eventually adding you to the /dev/null redirect.

