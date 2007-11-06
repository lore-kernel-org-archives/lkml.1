Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbXKFSem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbXKFSem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbXKFSec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:34:32 -0500
Received: from mx0.starentnetworks.com ([12.38.223.203]:33821 "EHLO
	mx0.starentnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbXKFSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:34:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18224.46001.836006.507154@zeus.sw.starentnetworks.com>
Date: Tue, 6 Nov 2007 13:34:25 -0500
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: "Ramkrishna Vepa" <Ramkrishna.Vepa@neterion.com>
Cc: "David Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>, <bguo@sw.starentnetworks.com>
Subject: RE: [PATCH 2/2] NET: Re-add VLAN tag for devices incapable of keeping it
In-Reply-To: <78C9135A3D2ECE4B8162EBDCE82CAD77027E9E9E@nekter>
References: <78C9135A3D2ECE4B8162EBDCE82CAD77027E9D5E@nekter>
	<78C9135A3D2ECE4B8162EBDCE82CAD77027E9E9E@nekter>
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkrishna Vepa writes:
> Dave,
> 
> If you can remove the patch for the s2io driver, we can submit a patch
> that can dynamically program Xframe to strip or not strip the vlan tag
> based on whether the vlan group is not NULL or NULL respectively. For
> this, we have to modify the initialization as well as the vlan
> registration.

Sure, not having this hardware I didn't want to attempt a complicated
change.  I'll let you take care of this.

-- 
Dave Johnson
Starent Networks

