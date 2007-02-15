Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbXBOXd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbXBOXd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXBOXd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:33:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:43154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbXBOXd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:33:56 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] add CONFIG_PNP=y to x86_64 defconfig
Date: Fri, 16 Feb 2007 00:33:37 +0100
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Adam Belay <abelay@novell.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <200702151742.15188.lenb@kernel.org>
In-Reply-To: <200702151742.15188.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702160033.37241.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Maybe we should select CONFIG_PNP from CONFIG_ACPI?

That would be probably better I think because it will fix existing
user configurations. You'll get the defconfig for free with that too.

-Andi
