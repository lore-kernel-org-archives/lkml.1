Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbXEQVo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbXEQVo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbXEQVor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:44:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbXEQVoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:44:46 -0400
Date: Thu, 17 May 2007 17:43:24 -0400
From: Dave Jones <davej@redhat.com>
To: Ed Sweetman <safemode2@comcast.net>
Cc: Len Brown <lenb@kernel.org>, Daniel Drake <dsd@gentoo.org>,
       duaneg@dghda.com, prakash@punnoor.de, jhoblitt@ifa.hawaii.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-ID: <20070517214324.GB398@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ed Sweetman <safemode2@comcast.net>, Len Brown <lenb@kernel.org>,
	Daniel Drake <dsd@gentoo.org>, duaneg@dghda.com, prakash@punnoor.de,
	jhoblitt@ifa.hawaii.edu, linux-kernel@vger.kernel.org
References: <20070516235050.9B4237B409F@zog.reactivated.net> <200705171413.42595.lenb@kernel.org> <20070517182340.GA25691@redhat.com> <464CC920.6030409@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464CC920.6030409@comcast.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 05:29:04PM -0400, Ed Sweetman wrote:

 > Every other cpufreq driver demands acpi

This isn't true.

	Dave

-- 
http://www.codemonkey.org.uk
