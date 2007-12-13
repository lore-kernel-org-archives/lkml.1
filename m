Return-Path: <linux-kernel-owner+w=401wt.eu-S933312AbXLMVu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbXLMVu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbXLMVuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:50:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933AbXLMVuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:50:11 -0500
Message-ID: <4761A8B6.8050302@ce.jp.nec.com>
Date: Thu, 13 Dec 2007 16:48:38 -0500
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz, jbeulich@novell.com,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Subject: Re: [PATCH] PCI: Remove default PCI expansion ROM memory allocation
References: <20071212010925.GD6755@us.ibm.com>
In-Reply-To: <20071212010925.GD6755@us.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade wrote:
> Remove default PCI expansion ROM memory allocation

Thank you Gary for the new patch.

By not allocating resources for expansion ROM,
this patch will eliminate the problem that my patch masked, too:
http://lkml.org/lkml/2007/12/4/284

Regards,
-- 
Jun'ichi Nomura, NEC Corporation of America
