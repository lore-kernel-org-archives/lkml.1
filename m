Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab0BRPOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:14:36 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:54441 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab0BRPOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:14:35 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B7D59C3.90301@cam.ac.uk>
Date: Thu, 18 Feb 2010 15:16:19 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: linux-next: manual merge of the als tree with Linus' tree
References: <20100218171147.973d1016.sfr@canb.auug.org.au>
In-Reply-To: <20100218171147.973d1016.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/10 06:11, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the als tree got a conflict in drivers/misc/Kconfig between commit 8c5d30e590593495c5bb8bd4a2519ce1ac909a22 ("dell-laptop: remove duplicate Kconfig entry under drivers/misc") from Linus' tree and commit 6600f58cfc348ef5862876ab4965d95aad793429 ("isl29003: Move from misc to als now it available with minimal changes") from the als tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the change
> for a while.
Thanks Stephen and sorry for wasting your time!

I've reset that last patch, merged Linus' current tree and reapplied it on top with the
merge problems fixed up.  While I was there I edited the commit message so it was actually
English (oops).

Anyhow, (fingers crossed), it should now work fine.

Jonathan
