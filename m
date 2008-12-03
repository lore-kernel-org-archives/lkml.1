Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYLCTCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYLCTCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYLCTC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:02:27 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:52277 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYLCTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:02:26 -0500
Date: Wed, 03 Dec 2008 14:01:47 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
In-reply-to: <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
X-X-Sender: lenb@localhost.localdomain
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Message-id: <alpine.LFD.2.00.0812031359001.3255@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Mimi Zohar wrote:

> +config IMA
> +	bool "Integrity Measurement Architecture(IMA)"
> +	depends on INTEGRITY
> +	depends on ACPI

ACPI?  why?
-- 
-Len Brown
Intel Open Source Technology Center


