Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYJNV0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYJNV0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYJNV0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:26:13 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:44455 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYJNV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:26:12 -0400
Date: Tue, 14 Oct 2008 15:26:08 -0600
From: Alex Chiang <achiang@hp.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pci <linux-pci@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: question about pci_disable_device
Message-ID: <20081014212608.GA14596@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Oliver Neukum <oliver@neukum.org>,
	linux-pci <linux-pci@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <200810131947.44992.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810131947.44992.oliver@neukum.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

* Oliver Neukum <oliver@neukum.org>:
> Hi,
> 
> could somebody explain what determines when in the sequence of hot
> unplugging pci_disable_device() is called?

I don't know the answer, but you might have better luck cc'ing
the linux-pci list too.

/ac

