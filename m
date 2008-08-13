Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYHMK2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYHMK2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYHMK2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:28:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57030 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYHMK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:28:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48A2B723.70305@s5r6.in-berlin.de>
Date: Wed, 13 Aug 2008 12:27:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: grundler@google.com, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH update] ieee1394: sbp2: enforce s/g segment size limit
References: <20080809071744I.fujita.tomonori@lab.ntt.co.jp> <tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de> <da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com> <20080813084514K.fujita.tomonori@lab.ntt.co.jp> <tkrat.a77de871a8213efc@s5r6.in-berlin.de>
In-Reply-To: <tkrat.a77de871a8213efc@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> -		if (dma_mapping_error(cmd->cmd_dma)) {

PS:  That's the 2.6.26 version; the 2.6.27 patch has an additional 
argument here, if anybody cares...
-- 
Stefan Richter
-=====-==--- =--- -==-=
http://arcgraph.de/sr/
