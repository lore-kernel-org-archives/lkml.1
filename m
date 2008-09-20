Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYITK7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYITK7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYITK7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:59:31 -0400
Received: from web52911.mail.re2.yahoo.com ([206.190.49.21]:38094 "HELO
	web52911.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751379AbYITK7a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:59:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=yrEMoDDxXjS+Abr0sRA/jC2oKZc06e0ixS7LqzEA6pJoVO5ZVfU1onnhW5XtFZpuYoq/gC27/uWw4CcEgl8j3hPHHKvNp5erVhQddUve8f7dytkJ+3tNy5kwYNs2Rq18hZEpeMgwgk6UF0LiL7lK9s+S5VvTy2ykjcMe36PIRIg=;
X-YMail-OSG: BgvjAwIVM1lcRvm5jXXLZfGvztUXlHKtft0EK.yELEQ_P4QCN1hfhR36D6UyKVxgiFdjIvopzxSXMGklMxepHkzXV1AqPvKdvwbXnJ1euGsVGFqcNE7TS.x2CQgh5FpfzdD_h19kjAHeZQik.QTz3YFAxzRDERIuXagDjrIagFYUAjM-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Sat, 20 Sep 2008 03:59:28 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: rankincj@yahoo.com
Subject: Re: Thinkpad T60p does not recover from Suspend when docked.
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48D3C67B.70909@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <180616.16497.qm@web52911.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 19/9/08, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> If you are using binary only graphics card drivers does the
> problem also happen without them never loaded at all?

I have just replicated the problem exactly without the fglrx module (ever) loaded at all, and using the very latest radeonhd DDX driver instead. So this really IS *just* to do with the SATA drive in the docking station.

Cheers,
Chris




      
