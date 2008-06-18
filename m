Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYFRWdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYFRWdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYFRWdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:33:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:59508 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbYFRWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eM4JzPyltxaKSSyF3H+thHXXrU+bPu4LGOveqsb9E9URgFNCpPE2qwvPx79/R1snVz
         12mdqRXhzkXkX7+54Zjtb/BBZEvTi8+gnlmC6BHExmLNMS3cmbY6xoyNlbgIFEzEqiUQ
         Di/g+oLW9MTGKoszCYGo4VkZzQxXmkj0Y0lpE=
Message-ID: <48598D3F.4000505@gmail.com>
Date: Thu, 19 Jun 2008 00:33:35 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
CC: "'Ryo Tsuruta'" <ryov@valinux.co.jp>, axboe@kernel.dk, vtaras@openvz.org,
       containers@lists.linux-foundation.org, tom-sugawara@ap.jp.nec.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][v2][patch 0/12][CFQ-cgroup]Yet another I/O bandwidth controlling
 subsystem for CGroups based on CFQ
References: <20080513.003316.226782406.ryov@valinux.co.jp>	<20080522.220438.226802699.ryov@valinux.co.jp>	<003701c8bc80$3a5f9ec0$af1edc40$@jp.nec.com> <20080526.114627.104044752.ryov@valinux.co.jp> <004f01c8bfed$640fa380$2c2eea80$@jp.nec.com> <483FD8E5.2080600@gmail.com> <001501c8d128$76e734e0$64b59ea0$@jp.nec.com>
In-Reply-To: <001501c8d128$76e734e0$64b59ea0$@jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Satoshi UCHIDA wrote:
> Hi, Andrea.
> 
> Thanks for bug reports.
> I fix this problem.
> 
> This problem causes by miss of trace for children groups.
> Please adopt and test this patch.

Thanks Satoshi, I'll test the fix in this weekend and I'll let you know.

-Andrea

> 
> If OK, this amendment is adopted when I release new patch-set.
> 
> 
> Regards,
>  Satoshi Uchida.
