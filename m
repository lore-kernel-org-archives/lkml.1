Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZG0DLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZG0DLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 23:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZG0DLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 23:11:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:36500 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbZG0DLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 23:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SQ1tzdLRZzFJsuqX2AhMD8CfEUiTLuD0keBYNKPbS00MM/ks6PEIA0S6r186P22fGj
         5Lopax+QrH6CCDxCVrHa9/cNp9NF56HJwcSGdSUy+WQFxX6MMScDsWT/W9hMeE4NeMqT
         bo7TTeOIs+heMNdLGaro5clP3nIk0idu4ntwA=
Message-ID: <4A6D1AF3.2020105@gmail.com>
Date: Mon, 27 Jul 2009 11:11:47 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
       Russell King <linux@arm.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch RFC 33/37] arm: w90x900: convert semaphore to mutex
References: <20090726081459.455111897@linutronix.de> <20090726081557.639168910@linutronix.de>
In-Reply-To: <20090726081557.639168910@linutronix.de>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas,

Thanks for your help, I have tested it ,which works well.
 
Acked-by: Wan ZongShun <mcuos.com@gmail.com>

