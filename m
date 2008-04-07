Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYDGXAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYDGXAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYDGXAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:00:06 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:42439 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbYDGXAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:00:05 -0400
Date: Mon, 7 Apr 2008 17:59:49 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: jwboyer@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 resend][PPC] replace logical by bitand in
 pci_process_ISA_OF_ranges(), arch/powerpc/kernel/isa-bridge.c
Message-ID: <20080407225949.GW7137@localdomain>
References: <47FA9FA6.8090201@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FA9FA6.8090201@tiscali.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> replace logical by bit and for ISA_SPACE_MASK

I think Paul has picked this up now:

http://ozlabs.org/pipermail/linuxppc-dev/2008-April/054103.html
