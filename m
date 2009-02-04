Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbZBDERo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbZBDERo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 23:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZBDER1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 23:17:27 -0500
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:46290 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752923AbZBDER0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 23:17:26 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 23:17:25 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=UUKRvQKQrMhgIHtLj2HW05Rb9npzNsuJwT76+y48w0viKtitpNm2o/3LY1JnBHaVGg83cnEhYKq1pf7HEUxBxzf+hxu872FJXmDNnQtY36LJQyE50TGtVA3D7mdT3Er04KURHbLwtrAHsqUe1TAwmZjW8+TydMKN2bMT+QEksyU=;
X-YMail-OSG: mnsOWYEVM1mPZzWHu.VgX8sFV3Xds1LB_nI6vC9FcDg4zKWH6lsWS_NFTAz0uz43qCrxXX2p974O3hbJV4pPwrL0tjdpcV5rSAiuEjHyCH_JqxYrYoAGArgHRjhGV1XrRMX5x1PRHx11tQKcWfx.JZsmMFnADUjBEwe6.0hpFDksKrqnh25Nbmhmkzsf
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 3 Feb 2009 20:10:44 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: oakad@yahoo.com
Subject: Support for direct IO in RapidIO susbsystem
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <546742.44897.qm@web37601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

I was browsing through kernel code and found no support for mmaping of remote RapidIO device address ranges. Therefore some questions:

1. Is there any open-source implementation of this functionality? There are some vendor supplied close-source drivers which do this.
2. Are there any specific plans to implement it (agreed upon API, user space stuff, etc)?

Thanks.



      
