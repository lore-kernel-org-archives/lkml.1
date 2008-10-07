Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYJGBoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYJGBoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYJGBoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:44:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:39664 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYJGBoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ox00B6qJ4Gk23o/DDiadIqppiHV1pfcT7dpzctAYLFtWq80F1u50TzqWu57deAnM0G
         4dzQNgr/K8Pf6V45o471wbJMonLI/Fh3wVwVeCJ5g6fnyR4qAwMGrHV1VQc56/eBmImE
         qHJGo2HLGjkccMADvXbcNTFUIk84+2Yeij7/g=
Message-ID: <48EABE8E.9070809@gmail.com>
Date: Tue, 07 Oct 2008 10:42:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Linda Walsh <smartmontools@tlinx.org>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <Pine.LNX.4.64.0809142159550.18213@gc.phys.uwm.edu> <48E1B8F8.3090205@gmail.com> <48E26BDA.8080804@tlinx.org> <48E26E61.2010705@gmail.com> <48E34BC8.3050009@tlinx.org> <48E6DE07.70706@gmail.com> <48EAAF2E.4060407@tlinx.org> <48EAB672.3010209@gmail.com> <48EABD07.6030506@tlinx.org>
In-Reply-To: <48EABD07.6030506@tlinx.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> Controller is a Promise TX4/300

Yeap.  After the drive goes offline, does unplugging and replugging
the power cable to the harddrive makes it come back?

-- 
tejun
