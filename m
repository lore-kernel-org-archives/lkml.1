Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZLXNXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZLXNXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 08:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZLXNXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 08:23:00 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:47907 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZLXNW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 08:22:59 -0500
Date: Thu, 24 Dec 2009 14:22:57 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/9] arch/mips/alchemy: Correct code taking the size of a
 pointer
Message-ID: <20091224132257.GA29598@linux-mips.org>
References: <Pine.LNX.4.64.0912131240100.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912131240100.24267@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 12:40:39PM +0100, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> sizeof(dp) is just the size of the pointer.  Change it to the size of the
> referenced structure.

Thanks Julia, applied.

  Ralf
