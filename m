Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZFDPxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZFDPxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZFDPxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:53:36 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:24356 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbZFDPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:53:36 -0400
Message-ID: <4A27EEB8.6030408@oracle.com>
Date: Thu, 04 Jun 2009 08:56:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for June 4 (staging)
References: <20090604175657.1565ecba.sfr@canb.auug.org.au>
In-Reply-To: <20090604175657.1565ecba.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A27EDF7.02E5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090603:

drivers/staging/vt6655/built-in.o: In function `rotr1':
(.text+0x1a883): multiple definition of `rotr1'
drivers/staging/rt2860/built-in.o:(.text+0x17a9a): first defined here
drivers/staging/vt6655/built-in.o: In function `tkip_sbox':
(.text+0x1a850): multiple definition of `tkip_sbox'
drivers/staging/rt2860/built-in.o:(.text+0x17a6b): first defined here
drivers/staging/vt6655/built-in.o: In function `xor_32':
(.text+0x1e938): multiple definition of `xor_32'
drivers/staging/rt2860/built-in.o:(.text+0x1803c): first defined here
drivers/staging/vt6655/built-in.o: In function `xor_128':
(.text+0x1e910): multiple definition of `xor_128'
drivers/staging/rt2860/built-in.o:(.text+0x18018): first defined here


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
