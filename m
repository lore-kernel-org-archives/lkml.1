Return-Path: <linux-kernel-owner+w=401wt.eu-S1765258AbYBZWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765258AbYBZWgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYBZWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:36:04 -0500
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:42003 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751384AbYBZWgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:36:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1GTdoMkYqeK7kWbXnnLyNdgAC8smZponUmGmkY9IYGraTaFfci7vVxHU92SUDaOlW83MMQ+igOQlllQyzYyUACOmMmEdi4RY2bFRBb1o9ZDBCT5I6gu9s2/RSd2asrff92wKQllwi9An+nwMKU8QOZ24EbmUBp1RwlFAQBKDbIY=;
X-YMail-OSG: q4EsqxMVM1mhcEma4XMLUDqbqO0nKz2wdLg02m7v
Date: Tue, 26 Feb 2008 22:36:00 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
To: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080218050056.fb0fc0bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <667844.65249.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, this hang still exists in 2.6.24.3 and so I am still needing to boot with the acpi=noirq
parameter.

Cheers,
Chris


      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/
