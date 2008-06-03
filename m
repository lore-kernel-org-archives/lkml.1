Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYFCVMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYFCVMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYFCVLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:11:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59743 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbYFCVLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:11:52 -0400
Message-ID: <4845B382.20205@garzik.org>
Date: Tue, 03 Jun 2008 17:11:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: Nathan Lynch <ntl@pobox.com>,
       Hannes Hering <hannes.hering@linux.vnet.ibm.com>, tklein@de.ibm.com,
       themann@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       ossthema@de.ibm.com
Subject: Re: [PATCH 2/3] [2.6.26] ehea: Add dependency to Kconfig
References: <200805071443.20192.hannes.hering@linux.vnet.ibm.com>	 <20080528164405.GA4836@localdomain>	 <200806031007.40162.hannes.hering@linux.vnet.ibm.com>	 <20080603204908.GB7475@localdomain> <1212527335.23656.2.camel@badari-desktop>
In-Reply-To: <1212527335.23656.2.camel@badari-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
>> It would be nice to get this resolved for 2.6.26 -- this new
>> dependency causes working 2.6.25 configs to effectively fail (by
>> deselecting CONFIG_EHEA during make oldconfig).


When everybody else is happy, I'm happy :)

