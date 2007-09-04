Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbXIDEMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbXIDEMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 00:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750731AbXIDEM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 00:12:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59068 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXIDEM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 00:12:29 -0400
Date: Tue, 4 Sep 2007 05:12:28 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Pallewatta Mano-FPCD67 <Mano.Pallewatta@motorola.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-2.6.16.51 gzipped core dump patch
Message-ID: <20070904041228.GZ21089@ftp.linux.org.uk>
References: <1188AA083E6C7C4EBCE34803004A84014FE921@de01exm72.ds.mot.com> <20070904013811.GX21089@ftp.linux.org.uk> <1188AA083E6C7C4EBCE34803004A84014FE926@de01exm72.ds.mot.com> <20070904032637.GY21089@ftp.linux.org.uk> <1188AA083E6C7C4EBCE34803004A84014FE932@de01exm72.ds.mot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188AA083E6C7C4EBCE34803004A84014FE932@de01exm72.ds.mot.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 12:04:37AM -0400, Pallewatta Mano-FPCD67 wrote:
> This support was there in the 2.6.16.51 kernel. In fact there was no
> call_usermodehelper_pipe().

So backport it, instead of creating an incompatible interface and headache
when you eventually rebase to later kernel.
