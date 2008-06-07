Return-Path: <linux-kernel-owner+w=401wt.eu-S1761109AbYFGFwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109AbYFGFwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 01:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbYFGFwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 01:52:35 -0400
Received: from ozlabs.org ([203.10.76.45]:57693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYFGFwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 01:52:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18506.8511.894470.70244@cargo.ozlabs.ibm.com>
Date: Sat, 7 Jun 2008 15:48:47 +1000
From: Paul Mackerras <paulus@samba.org>
To: Nathan Lynch <ntl@pobox.com>
Cc: tklein@de.ibm.com, Jeff Garzik <jeff@garzik.org>, themann@de.ibm.com,
       Hannes Hering <hannes.hering@linux.vnet.ibm.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org, raisch@de.ibm.com,
       Badari Pulavarty <pbadari@us.ibm.com>, ossthema@de.ibm.com
Subject: Re: [PATCH 1/2] make walk_memory_resource available with
 MEMORY_HOTPLUG=n
In-Reply-To: <20080606230638.GC6638@localdomain>
References: <200805071443.20192.hannes.hering@linux.vnet.ibm.com>
	<20080528164405.GA4836@localdomain>
	<200806031007.40162.hannes.hering@linux.vnet.ibm.com>
	<20080603204908.GB7475@localdomain>
	<1212527335.23656.2.camel@badari-desktop>
	<4845B382.20205@garzik.org>
	<20080603223054.GC7475@localdomain>
	<20080606230638.GC6638@localdomain>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch writes:

> Paul, can you take these two patches, or should I send them to akpm?

I'll take them.  I assume we want this in 2.6.26.

Paul.
