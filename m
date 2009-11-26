Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZKZDAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZKZDAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZKZDAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:00:44 -0500
Received: from ozlabs.org ([203.10.76.45]:33245 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbZKZDAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:00:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19213.61231.695292.875347@drongo.ozlabs.ibm.com>
Date: Thu, 26 Nov 2009 13:59:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 3/3]CPU DLPAR handling
In-Reply-To: <4B0CD91C.1090704@austin.ibm.com>
References: <4B0CD70F.6090600@austin.ibm.com>
	<4B0CD91C.1090704@austin.ibm.com>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot writes:

> This patch adds the specific routines to probe and release (add and remove)
> cpu resource for the powerpc pseries platform and registers these handlers
> with the ppc_md callout structure.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: Paul Mackerras <paulus@samba.org>
