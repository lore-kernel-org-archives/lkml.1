Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYFPHON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYFPHON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYFPHN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:13:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:44286 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYFPHN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:13:57 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <18518.114.100584.607669@cargo.ozlabs.ibm.com>
References: <18518.114.100584.607669@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 17:13:22 +1000
Message-Id: <1213600402.8129.127.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 15:56 +1000, Paul Mackerras wrote:
> Please pull from the 'merge' branch of
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge
> 
> to get some more bug fixes and defconfig updates for powerpc, as
> listed below.  Almost all of the bulk is in the defconfig updates for
> the Freescale embedded platforms.

Paul, did you have a chance to fix our defconfig's for the loss of
SFF support in libata ?

Cheers,
Ben.


