Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbXLCV5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbXLCV5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXLCV5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:57:09 -0500
Received: from kuber.nabble.com ([216.139.236.158]:39629 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXLCV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:57:07 -0500
Message-ID: <14139669.post@talk.nabble.com>
Date: Mon, 3 Dec 2007 13:57:06 -0800 (PST)
From: Michael_chen <mchen@tannerycreeksystems.com>
To: linux-kernel@vger.kernel.org
Subject: Built-in modules for PCI devices
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: mchen@tannerycreeksystems.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi guys,

Can anybody tell me how to find the mapping of PCI PnP ids for those
built-in modules(linked into kernel). AFAICT, PnP id and module mapping
could be found in /lib/modules/`uname -r`/modules.pcimap for the loadable
modules. I think there should be a table or list for the mapping between PnP
ids and modules loaded into kernel inside kernel space. My question is if it
could be accessed in user space and how to do it if possible.

Thanks in advance,

-Michael  
-- 
View this message in context: http://www.nabble.com/Built-in-modules-for-PCI-devices-tf4939545.html#a14139669
Sent from the linux-kernel mailing list archive at Nabble.com.

