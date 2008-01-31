Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbYAaPRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbYAaPRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYAaPRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:17:22 -0500
Received: from greensrv.RZ.UniBw-Muenchen.de ([137.193.10.35]:36933 "EHLO
	GreenSrv.rz.unibw-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbYAaPRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:17:22 -0500
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 10:17:21 EST
X-Remarks: If SPAM is relayed via GreenSrv.rz.unibw-muenchen.de to outside of unibw-muenchen.de, please report it to abuse@unibw-muenchen.de
Message-ID: <47A1DE20.5030305@pc0312b.rz.unibw-muenchen.de>
Date: Thu, 31 Jan 2008 15:41:36 +0100
From: Claude Frantz <claude@pc0312b.rz.unibw-muenchen.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: OOM-killer invoked but why ?
References: <47A1C4B1.8020607@pc0312a.rz.unibw-muenchen.de> <1201790191.32654.7.camel@lappy>
In-Reply-To: <1201790191.32654.7.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> You seem to have ran out of zone normal memory with all of it stuck in
> kernel allocations. Would you have /proc/slabinfo available?

Thanks Peter !

No ! There is no /proc/slabinfo available.

Claude
