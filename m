Return-Path: <linux-kernel-owner+w=401wt.eu-S1751323AbZD3Hkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbZD3Hkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZD3HkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:40:24 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:57818 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751187AbZD3HkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:40:23 -0400
Message-ID: <441077283.08393@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: ylmao@mail.ustc.edu.cn
From: "Mao Yilu" <ylmao@mail.ustc.edu.cn>
To: "'Henrique de Moraes Holschuh'" <hmh@hmh.eng.br>
Cc: <linux-kernel@vger.kernel.org>
References: <440758024.12507@ustc.edu.cn> <441049102.10204@ustc.edu.cn> <654E14825BCE4C9B94E5986000DC9BCE@xiaomao> <441061189.03958@ustc.edu.cn>
Subject: RE: TSC unstable on Intel Pentium M processor 750
Date: Thu, 30 Apr 2009 15:40:02 +0800
Message-ID: <70DF5CB591F94B45BBC9BD2D41A047EF@xiaomao>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <441061189.03958@ustc.edu.cn>
Thread-Index: AcnJQZZk2gU7R1ONQs+LH5d8kg7hsgAJJBXA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Henrique de Moraes
> Holschuh
> Sent: Thursday, April 30, 2009 11:12 AM
> To: Mao Yilu
> Cc: 'Robert Hancock'; linux-kernel@vger.kernel.org
> Subject: Re: TSC unstable on Intel Pentium M processor 750
> 
> On Thu, 30 Apr 2009, Mao Yilu wrote:
> > But I still don't know why the TSC is not correct in the C1 state (hlt
> > instruction). Is there anything more to influence the TSC? What happened
> > when the CPU is not running under hlt instruction?
> 
> SMIs?  Laptops love that crap...

What is SMIs?


