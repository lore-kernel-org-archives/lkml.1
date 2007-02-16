Return-Path: <linux-kernel-owner+w=401wt.eu-S1946173AbXBPSSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946173AbXBPSSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946182AbXBPSSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:18:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946173AbXBPSSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:18:01 -0500
Message-ID: <45D5F489.1010704@redhat.com>
Date: Fri, 16 Feb 2007 13:14:33 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: Could the k8temp driver be interfering with ACPI?
References: <45D5EA88.7090300@redhat.com> <200702161257.23684.lenb@kernel.org>
In-Reply-To: <200702161257.23684.lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
>> So, could ACPI and the k8temp driver be at odds?
> 
> 
> Yes.

Hmm, now it's showing 130 degrees once every five seconds
and 54 degrees for the other four.

And while I was typing this on another machine I heard a
click from the notebook -- it shut down again.

