Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbYLEP5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbYLEP5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYLEP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:57:11 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:48944 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750781AbYLEP5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:57:11 -0500
Date: Fri, 5 Dec 2008 15:56:54 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Jonathan Corbet <corbet@lwn.net>,
       "Kevin D. Kissell" <kevink@paralogos.com>,
       Lucas Woods <woodzy@gmail.com>, linux-mips@linux-mips.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix incorrect use of loose in vpe.c
Message-ID: <20081205155654.GA2765@linux-mips.org>
References: <S24119814AbYLEAhF/20081205003705Z+5882@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S24119814AbYLEAhF/20081205003705Z+5882@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 11:36:54AM +1100, Nick Andrew wrote:
> From: Nick Andrew <nick@nick-andrew.net>
> Date: Fri, 05 Dec 2008 11:36:54 +1100
> To: Jonathan Corbet <corbet@lwn.net>, "Kevin D. Kissell" <kevink@mips.com>,
> 	Lucas Woods <woodzy@gmail.com>, Nick Andrew <nick@nick-andrew.net>,
> 	Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Subject: Fix incorrect use of loose in vpe.c
> 
> Fix incorrect use of loose in vpe.c
> 
> From: Nick Andrew <nick@nick-andrew.net>
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Thanks, applied.  Note that the address you used for Kevin Kissel to post
your patch is no longer valid.

  Ralf
