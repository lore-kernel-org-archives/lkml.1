Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZIXG6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZIXG6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 02:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZIXG6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 02:58:00 -0400
Received: from web8404.mail.in.yahoo.com ([202.43.219.152]:37097 "HELO
	web8404.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751134AbZIXG6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 02:58:00 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 02:57:59 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=nsw5Yhyz2hBb31nSogFh8pzcjdxDXiS1U1ubQwzwh6HnbCX5qZh+Aage0S1KiqgtxS8+Mv0Xd4UGzgABTnBgQgHM/qEcud6cJJVPUYhTnJhP8YkZkZgJ/cDec9XPoQj2TntWVP7xvbVS4nmJTYNCAI91ZWl2h/72ZLN6pIJU9ik=;
Message-ID: <179773.9311.qm@web8404.mail.in.yahoo.com>
X-YMail-OSG: OKuNjjYVM1l6zc3l.JX1_WL_WbE9pvpL426CnXsN0vKm_VHP5dUA0YiTHA4prGeVDBL_QbAyHOlrEXOAzowYjuWAQTQjYoQJ7cYYjMMYPzJ50vBypPKPMsTMRvhm9cNXHExZxfMCRtKmQAsPk8zqZexQ4gmqPJOyN3o1dIoOeURJTSj.B7GLBcPj89HLcGDKbv_acjbA.8MSKai0mjzHnX0KWHrZshBB_ODjWsriHqAPEzyVQexEOSCKmgeadKv8D9eIFEm96b_vKdgvsPcNqgQ-
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.2
Date: Wed, 23 Sep 2009 23:51:19 -0700 (PDT)
From: KV Pavuram <kvpavuram@yahoo.co.in>
Subject: Socket vs File descriptor
To: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any  ioctl call to determine if a given descriptor is a file descriptor or a socket descriptor.

Similarly, is there a way to find out a socket descriptor type ie.e if it is SOCK_STREAM, or SOCK_DGRAM type.

Thanks
Pav


      See the Web&#39;s breaking stories, chosen by people like you. Check out Yahoo! Buzz. http://in.buzz.yahoo.com/
