Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbXGXGfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbXGXGfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXGXGfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:35:46 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:51223 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXGXGfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QcoI66CdMhOEb9Au6pB6NgivqiP29GCAOyhpoJ+nlVlhiC+otpbbqrdCAweVsXR/27GOHNPnu9WJ1PUN//6Ju1cy03hBut0IRf0C4vZ6Ul5VE+CU7GwHjmwqtdeH+1cMowKuFTar/u4sSAGQWAYH2xy/YuZ9UBKbR/grr9OLJcA=
Message-ID: <46A59DBA.4000704@gmail.com>
Date: Tue, 24 Jul 2007 15:35:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>	<a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	<469A5C94.7030201@googlemail.com>	<a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>	<469A9D5D.10509@googlemail.com>	<469B61C8.8010902@googlemail.com>	<a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>	<469BB7B8.3060002@gmail.com>	<469BB9CA.6090500@googlemail.com>	<469BC2D6.5090008@googlemail.com>	<469BC34C.4080107@googlemail.com>	<469DAA52.1010803@gmail.com> <20070723125323.27a864f7@schroedinger.engr.sgi.com>
In-Reply-To: <20070723125323.27a864f7@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 18 Jul 2007 14:51:14 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Okay, successfully reproduced here.  Will hunt down.
> 
> Next time simply boot with "slub_debug". It will save a lot of time.

Alright, thanks.

-- 
tejun
