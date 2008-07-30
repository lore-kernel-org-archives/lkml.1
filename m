Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYG3VJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYG3VJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbYG3VJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:09:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:56471 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbYG3VJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YI5uLvrNweT9fFN3LImOPdI4BlZTQRO43cOOknohkvrXRA14U6l4yiTc/03V/cNIfI
         WnSWlwoWkSw2F/hhaUUDJmKhG3H3m9yKAdGPZcKrpOeLT6nS6248MkkSLOMVEkqyk3hD
         n6Sr4ZukW15enr/VGxclNKgw6muwO9CtAMMyQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/7] dyn_array support
Date: Wed, 30 Jul 2008 12:10:30 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807292138.41720.yhlu.kernel@gmail.com> <200807300311.48510.yhlu.kernel@gmail.com>
In-Reply-To: <200807300311.48510.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301210.31511.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the patches adding dyn_array and nr_irqs

Thanks

YH
