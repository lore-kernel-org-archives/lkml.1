Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXFMSbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXFMSbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbXFMSb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:31:29 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:19954 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291AbXFMSb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:31:27 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
In-Reply-To: <20070613.112319.78711331.davem@davemloft.net>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613.112319.78711331.davem@davemloft.net>
Content-Type: text/plain
Organization: IBM
Date: Wed, 13 Jun 2007 20:27:51 +0200
Message-Id: <1181759271.26375.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 11:23 -0700, David Miller wrote:
> I think my general response to something like this, if it goes
> in, would be to stop emitting useful kernel log messages
> in the code I write because having to document it too on top
> of that is just too much extra work to be worthwhile.

Nobody will force you to document your messages. As I said, there is no
need to document self-explaining printks.

Michael

