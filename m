Return-Path: <linux-kernel-owner+w=401wt.eu-S934452AbXJPQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbXJPQDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbXJPQDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:03:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582AbXJPQDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:03:03 -0400
Message-ID: <4714E00D.2000505@redhat.com>
Date: Tue, 16 Oct 2007 12:00:13 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Konstantin Kalin <konstantin.kalin@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
References: <4714C66D.4010607@gmail.com>
In-Reply-To: <4714C66D.4010607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kalin wrote:
> P.S. It's simple to add DEV_HAS_CORRECT_MACADDR to pci_device_tlb for 
> these types of Ethernet. But I think it's not right decision because it 
> would break older revisions of these models.

Any reason you can't distinguish based on PCI ID?

	-- Chris
