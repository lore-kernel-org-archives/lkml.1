Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbZBYPc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbZBYPc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761782AbZBYPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:32:45 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52941 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641AbZBYPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:32:44 -0500
Date: Wed, 25 Feb 2009 10:32:31 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       akpm@linux-foundation.org, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, lho@amcc.com, kaber@trash.net,
       darrenrjenkins@gmail.com, Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
Message-ID: <20090225153231.GA16691@hmsreliant.think-freely.org>
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A55B5A.70705@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 03:53:14PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Applying kernel janitors todos (printk calls need KERN_*
> constants on linebeginnings, reduce stack footprint where
> possible) to tcrypts test_hash_speed (where stacks
> memory footprint was very high (on i386 1184 bytes to
> 160 now).
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
Looks good, thanks Frank
Acked-by: Neil Horman <nhorman@tuxdriver.com>

