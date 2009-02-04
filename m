Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbZBDRJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbZBDRJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZBDRJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:09:29 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1859 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752728AbZBDRJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:09:28 -0500
Message-ID: <4989CB58.5000509@myri.com>
Date: Wed, 04 Feb 2009 12:07:36 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ed Swierk <eswierk@aristanetworks.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
References: <1233765552.16414.6.camel@localhost.localdomain>
In-Reply-To: <1233765552.16414.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2009 11:39 AM, Ed Swierk wrote:
> Detect and enable memory-mapped PCI configuration space on the nVidia
> MCP55 southbridge even if the ACPI MCFG table is missing or wrong.
>
>   


Minor question: there are motherboards with two MCP55 southbridges. 
Would the patch support mmconfig for both?


Loic


