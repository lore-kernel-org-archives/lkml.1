Return-Path: <linux-kernel-owner+w=401wt.eu-S1761142AbYBEUkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761142AbYBEUkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbYBEUkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:40:31 -0500
Received: from smtp.digitalpath.net ([65.164.104.14]:59211 "EHLO
	smtp.digitalpath.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760904AbYBEUka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:40:30 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=digitalpath.net;
  b=1ZuZXcBl5I4hRWxnz2p3vXi7pBEUPQ9KF3SlH5/Ym5hXsS3/CPf1T+kcNvkOExmTFBX6C8VIN23vqST4clonSk176xCDjVT4last+sdh/qwFFO0xdrpa/BAtVqMBO8BX  ;
Message-ID: <2048.65.164.104.9.1202244027.squirrel@webmail.digitalpath.net>
Date: Tue, 5 Feb 2008 12:40:27 -0800 (PST)
Subject: CS5536 How to detect a  reset by the WDT?
From: "Hasan Rashid" <hasan@digitalpath.net>
To: linux-kernel@vger.kernel.org
Reply-To: hasan@digitalpath.net
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone know if there is a way to detect a reset caused by the MFGPT
WDT in CS5536? I am using the ALiX2c0 boards.

TIA!
-- 
Regards, Hasan R.


