Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYA3Mo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYA3Mo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 07:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYA3MoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 07:44:19 -0500
Received: from web52004.mail.re2.yahoo.com ([206.190.49.251]:28903 "HELO
	web52004.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753053AbYA3MoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 07:44:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=wwuCW/HNGs2dNQidgbL4qaGledAqugFa/bpBpAJtyuegH+U3mpyBcAQ3Bw4ZbDx/4FVWh3iHD9s3tZOWFf+crju3ggVT62PT6JkfwHEZ8IwU6HNot8eXtg8g7fapFV4NUZZ2DJn6XAwIIlkBe6R6dygWAt/WbQigPdwlIqUKJyw=;
X-YMail-OSG: K1_QzioVM1kHFMu8svaIVYyVpG28ZzSKcbkn3vSQm_Em7dEJ6abi3vGph9mk452wWpxt3Rb9h.2LtxtSZ0abTntXL2_FietX0N6oFGxSL9f3J0V.CZzAMBClagtkEsQ_Z2TVFFiOuD1FtA--
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.162
Date: Wed, 30 Jan 2008 04:44:17 -0800 (PST)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: ARP Bug?
To: jengelh@computergmbh.de
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <67062.74127.qm@web52004.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt:

>On Jan 30 2008 04:29, Matti Linnanvuori wrote:
>Jan Engelhardt:
>>> If you have the same subnet on multiple interfaces, only the
>>> first interface will be served.
>>
>>Does that comply with the standard?
>
>What standard?

ARP standard. I think it is RFC 826:
An Ethernet Address Resolution Protocol



      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
