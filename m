Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZBDRhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZBDRhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZBDRhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:37:40 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:33008 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZBDRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:37:39 -0500
MIME-Version: 1.0
In-Reply-To: <4989CB58.5000509@myri.com>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <4989CB58.5000509@myri.com>
Date: Wed, 4 Feb 2009 09:37:37 -0800
Message-ID: <9ae48b020902040937q15d8c158s86fbc358d03ee0ef@mail.gmail.com>
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
From: Ed Swierk <eswierk@aristanetworks.com>
To: Loic Prylli <loic@myri.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 9:07 AM, Loic Prylli <loic@myri.com> wrote:
> Minor question: there are motherboards with two MCP55 southbridges. Would
> the patch support mmconfig for both?

Can you point me to such a motherboard? I have only seen boards with
one MCP55 plus a C51 companion chip providing extra PCIe lanes.

--Ed
