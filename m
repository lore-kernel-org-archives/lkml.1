Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbXFMSXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbXFMSXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759352AbXFMSXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:23:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39891
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759332AbXFMSXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:23:02 -0400
Date: Wed, 13 Jun 2007 11:23:19 -0700 (PDT)
Message-Id: <20070613.112319.78711331.davem@davemloft.net>
To: holzheu@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1181747217.29512.9.camel@localhost.localdomain>
References: <1181747217.29512.9.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I think my general response to something like this, if it goes
in, would be to stop emitting useful kernel log messages
in the code I write because having to document it too on top
of that is just too much extra work to be worthwhile.
