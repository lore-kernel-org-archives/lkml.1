Return-Path: <linux-kernel-owner+w=401wt.eu-S933207AbYCACEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbYCACEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 21:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbYCACEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 21:04:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36651 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbYCACEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 21:04:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 1 Mar 2008 03:04:33 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/3] firewire: fw-ohci: PPC PMac platform code
To: linux1394-devel@lists.sourceforge.net
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
Message-ID: <tkrat.22bd59f45b86b11c@s5r6.in-berlin.de>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
 <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> +		struct device_node* ofn = pci_device_to_OF_node(dev);

-ECOPYANDWASTE:	struct device_node *ofn

-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/

