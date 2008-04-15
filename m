Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbYDOBAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbYDOBAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbYDOA7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 20:59:52 -0400
Received: from web65602.mail.ac4.yahoo.com ([76.13.9.70]:23740 "HELO
	web65602.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752964AbYDOA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 20:59:52 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 20:59:51 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3tsCkKTMQ54VeLapx0w+CTLR7fYdmRA4qd8XepKWE5VrjVVmxD+itAdgy0qwsfHZBS1ktXoLZ4jOpTIOj/mjX8pyDTO++rigCvNaqMd4Z4KUptikCDc4+vljwjO2FO3Hdov/xxqQeEfY9FTI5hRzc6UtL7yo766kOZA4m0uOIxk=;
X-YMail-OSG: 34tzseQVM1kqrriP6nvNFhsjjyUOxzT8Znrc2vXbnLrdIFVypzMeWi3PeZ12bQGeDm6fZdkJQntJK4WiKuxPmW123fR7lCc-
Date: Mon, 14 Apr 2008 20:53:10 -0400 (EDT)
From: Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: Re: [2.6 patch] drivers/char/rtc.c: make 2 functions static
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bwalle@suse.de>
In-Reply-To: <20080414184035.GA6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <95868.23457.qm@web65602.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Adrian Bunk <bunk@kernel.org> wrote:

> The following functions can now become static:
> - rtc_interrupt()
> - rtc_get_rtc_time()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by: Bernhard Walle <bwalle@suse.de>

Acked-by:  Paul Gortmaker <p_gortmaker@yahoo.com>




      __________________________________________________________________
Ask a question on any topic and get answers from real people. Go to Yahoo! Answers and share what you know at http://ca.answers.yahoo.com
