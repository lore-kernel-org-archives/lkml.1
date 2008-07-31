Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbYGaENY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbYGaENY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYGaENP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:13:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:33079 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYGaENO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:13:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lz1mBoV7PYAGVzLHom42d4MGXvzgBLfW8+gGsEnj3MGYDb3O6ZtpQq8m4npoO+ITQf
         4ICY0o/6mL59hkezvFyBbSw4xYN45q4M8vf+1SBRD0VdwxxU4nuAbaNjdn5UgiV3Y+SR
         +dhOHP8/UHpyVUzBjeguK/PoPBOWjZzCjf7Ns=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] dyn_array support #2
Date: Wed, 30 Jul 2008 21:09:21 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807300311.48510.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com>
In-Reply-To: <200807301210.31511.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302109.21519.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the patches adding dyn_array and nr_irqs #2

Thanks

YH
