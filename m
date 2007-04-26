Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXDZWwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXDZWwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbXDZWwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:52:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:46633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbXDZWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:52:19 -0400
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: sky2 regression in 2.6.21: Asus P5B-E Plus ethernet adapter no
 more supported
Date: Thu, 26 Apr 2007 15:50:50 -0700
Organization: OSDL
Message-ID: <20070426155050.7850bc16@freekitty>
References: <46311882.2040005@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1177627862 23765 10.8.0.230 (26 Apr 2007 22:51:02 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Thu, 26 Apr 2007 22:51:02 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 23:24:18 +0200
Francois SIMOND <curio@free.fr> wrote:

> Hello,
> 
> Lastest sky2 update between 2.6.21-rc7 and 2.6.21 final disables the support of the integrated ethernet adapter build on the Asus P5B-E Plus motherboard.


But the same hardware dies horribly on Gigabyte GA-965P motherboards.
Could you send me full lspci -vvx output. I'll re-enable it for Asus and add a block
for the Gigabyte boards. (sigh)
