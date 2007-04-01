Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbXDAQVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbXDAQVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933629AbXDAQVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:21:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:21253 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622AbXDAQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cj+wzBrVK6z/koCuJ5WfvR+/VP/RhnJ680BK5xShjX0uP/9U6D2PDCBVvuDzr6fy3JbShJyw/RBZ6qGXTF4amG20mYIYJD90XmJHdar1eV4oca8loEro0HRABLZzN2UU2FRvrZb9ElraEK8eLa5CI/reyEDxQAaBPLLJ7IrjEo0=
Message-ID: <460FDBF8.4040002@gmail.com>
Date: Mon, 02 Apr 2007 01:21:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [-mm patch] make drivers/ata/pata_ali.c:ali_tf_load() static
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331204856.GY14134@stusta.de>
In-Reply-To: <20070331204856.GY14134@stusta.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Mar 30, 2007 at 01:05:59AM -0700, Andrew Morton wrote:
>> ...
>> Changes since 2.6.21-rc5-mm2:
>> ...
>> +testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
>>
>>  pata experiment
>> ...
> 
> 
> This patch makes the needlesly global ali_tf_load() static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
