Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbYAYP7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbYAYP7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYAYP7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:59:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:34381 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbYAYP7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:59:10 -0500
Date: Fri, 25 Jan 2008 09:56:30 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Jochen Friedrich <jochen@scram.de>
cc: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCHv3 7/7] [POWERPC] Move definition of buffer descriptor to
 cpm.h
In-Reply-To: <4798ACA5.5050106@scram.de>
Message-ID: <Pine.LNX.4.64.0801250956180.16736@blarg.am.freescale.net>
References: <4798ACA5.5050106@scram.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, Jochen Friedrich wrote:

> Buffer descriptors are used by both CPM1 and CPM2. Move the definitions
> from the cpm dependent include file to common cpm.h
>
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
> include/asm-powerpc/cpm.h  |   73 ++++++++++++++++++++++++++++++++++++++++++++
> include/asm-powerpc/cpm1.h |   65 ---------------------------------------
> include/asm-powerpc/cpm2.h |   64 --------------------------------------
> 3 files changed, 73 insertions(+), 129 deletions(-)
>

applied.

- k
