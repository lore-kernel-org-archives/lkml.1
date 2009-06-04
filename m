Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZFDKcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZFDKcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZFDKcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:32:10 -0400
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:43436 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751181AbZFDKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:32:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uXkmpc+0bpfBUVFJ+a0gzR1mR0NhDULbgciFWuwxN4a0MT+R6nr5fykqeLib/jBR4b6S4G1Ea2y2VFxiZkbayzTf0qY166bSdzRiD07GBkkt2dGvqoNiWzGCsJronkNJ;
Date: Thu, 4 Jun 2009 11:32:05 +0100
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "marc.c.dionne@gmail.com" <marc.c.dionne@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: use fixed-up device class when configuring device
Message-ID: <20090604113205.20bf534e@jbarnes-x200>
In-Reply-To: <4A2333CF.2040601@intel.com>
References: <1243441505-5477-1-git-send-email-yu.zhao@intel.com>
	<20090529171956.GE28355@lackof.org>
	<4A2333CF.2040601@intel.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 158.43.2.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Jun 2009 09:50:07 +0800
Yu Zhao <yu.zhao@intel.com> wrote:

> Hi Jesse,
> 
> Can you please take this fix for 2.6.30 RC if possible? It fixes a 
> regression introduced by the SR-IOV patch series.

Applied to my for-linus tree.  I'll try to get it to Linus before he
releases the final 2.6.30.

Jesse
