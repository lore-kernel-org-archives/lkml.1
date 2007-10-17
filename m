Return-Path: <linux-kernel-owner+w=401wt.eu-S933424AbXJQNSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbXJQNSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXJQNR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:17:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:30815 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbXJQNR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=OhvuNCwexP7d/nwQw+zrUPLHqSHwzGautEYHIR/AKlo6S6+oNIfS/Y586hJpauFcHfydkqswkonI+ktl/31pxbDf/RKDbVlwUrMDrop+g/eNfvAwgxv3M+2p7g5G9ffQjq0fC7BuisDX3hTbLqcs26FxL5X1uZdIhrdEOjE6BnA=
Message-ID: <47160B7F.2040805@gmail.com>
Date: Wed, 17 Oct 2007 14:17:51 +0100
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, phil.lello@googlemail.com
Subject: USB Problems: HP ScanJet 5300C SET_ADDRESS fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Phil Lello <phil.lello@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been looking into a problem with my HP ScanJet 5300C not being 
detected by the USB stack, with a 2.6.20 kernel.

Bug #6078 was opened by someone else for this way back in Feb 2006, but 
then closed due to lack of user feedback in late August 2006.

I've added some comments to this as I've tested the patch, but I'm not 
sure if any current kernel developers are following this bug... should I 
open a new bug, as I can't change the status from REJECTED/INSUFFICIENT 
DATA?

I'm not on list, so a cc on replies would be greatly appreciated
Thanks,

Phil Lello
