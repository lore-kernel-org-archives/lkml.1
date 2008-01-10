Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYAJHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYAJHxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYAJHxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:53:14 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40083 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752502AbYAJHxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:53:13 -0500
Message-ID: <399951601.23683@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 10 Jan 2008 15:53:06 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: jplatte@naasa.net
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801091322.35133.lists@naasa.net> <399883439.31205@ustc.edu.cn> <200801091404.30330.lists@naasa.net> <20080110073046.GA3432@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110073046.GA3432@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JCsDr-0002cl-0e@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 03:30:46PM +0800, Fengguang Wu wrote:
> Joerg,
> 
> Can you try the attached patches? Thank you.
> I cannot reliably reproduce the bug yet.

Please ignore the first patch and only apply the two debugging 
patches. They will produce many printk messages. The output of 
`dmesg` will be enough for me.

Thank you,
Fengguang

