Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYBAWiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYBAWiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbYBAWhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:37:16 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:18239 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbYBAWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=q9xAe4MGtx+oUwtF+F0CTETrZZ+/Ropzq/KRw9BlVP0xn0AEmUtbbKAyz0HbnySS4ZpMVANhkTxWJXNbVlFb3O3m7ry/SKF1YB7eqg3e3i5UUixX0o6mmEOJ1i06qCVw08/uY3ZImpFWnElviStCnBkDEGjuYZMOIQ28RiZ99QM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] small ide-scan-pci.c cleanup
Date: Fri, 1 Feb 2008 22:50:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080128220950.GJ8767@does.not.exist>
In-Reply-To: <20080128220950.GJ8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802012250.59487.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Adrian Bunk wrote:
> - ide_scan_pcibus() can become static
> - instead of ide_scan_pci() we can use ide_scan_pcibus() directly
>   in module_init()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
