Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYHGTCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYHGTCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYHGTBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:01:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:56169 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYHGTBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:01:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xh04bIqqAdiBDHRqxkdRDh6vjSLeb66gb14WKArYgdhLq+8agwfSBJquconhHIqbAS
         beEXG4Qv4d1/c2/0kvDIpO97DQOPWyOnZn3iPLHDoJv+ArSK+ehRjEAiLzcgv5PRKXpq
         DAo6bU+J4eASAbE2DlFdcUZxH+0dW14lUqzc4=
Message-ID: <dd18b0c30808071201l5a13509alede392fe5c17baf@mail.gmail.com>
Date: Thu, 7 Aug 2008 12:01:50 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: cat /sys/devices/system/cpu/cpuidle/current_driver
Cc: "Rabin Vincent" <rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O.k. appologize for the delay,
(been dealing with the DMV, and
admiring how nice 2.6.27-rc1 is);
anyways applied the patch you gave me,
and yes:
cat /sys/devices/system/cpu/cpuidle/current_driver
gives me the right response.

regards;

-- 
Justin P. Mattock
