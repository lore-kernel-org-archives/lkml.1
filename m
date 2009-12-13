Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZLMUO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZLMUO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZLMUO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:14:26 -0500
Received: from lo.gmane.org ([80.91.229.12]:50952 "HELO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754116AbZLMUOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:14:25 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Arkadiusz =?UTF-8?B?TWnFm2tpZXdpY3o=?= <arekm@maven.pl>
Subject: Re: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems
Followup-To: gmane.linux.file-systems
Date: Sun, 13 Dec 2009 21:13:53 +0100
Message-ID: <hg3hu0$8h1$1@ger.gmane.org>
References: <E1NHYun-000287-Vq@dylan.lougher.demon.co.uk> <87tyw3p3vu.fsf@macbook.be.48ers.dk> <4B1E93E5.8090104@lougher.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: chello087207106200.chello.pl
User-Agent: KNode/4.3.4
Cc: linux-fsdevel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:

> Peter Korsgaard wrote:

>> Nice, do you also have an mksquashfs with lzma support?
>> 
> 
> Yes, in Squashfs CVS (http://sourceforge.net/projects/squashfs/develop).

Any reason for not using much nicer xz library instead of lzma sdk ? 

http://tukaani.org/xz/

> Phillip


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

