Return-Path: <linux-kernel-owner+w=401wt.eu-S1161182AbXBGKuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182AbXBGKuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161189AbXBGKuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:50:39 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49353 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161182AbXBGKuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:50:37 -0500
Date: Wed, 7 Feb 2007 12:50:34 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jan Kara <jack@suse.cz>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
In-Reply-To: <20070207104549.GF24590@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0702071248260.25085@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>
 <20070207104549.GF24590@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Honza,

On Wed, 7 Feb 2007, Jan Kara wrote:
>   Have you considered using similar hack as bad_inode.c instead of
> revoked_inode.c?

I am not sure what you mean, revoked_inode.c looks pretty much the same as 
bad_inode.c in mainline...

			Pekka
