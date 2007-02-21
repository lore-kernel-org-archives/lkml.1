Return-Path: <linux-kernel-owner+w=401wt.eu-S1751186AbXBUIZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbXBUIZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXBUIZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:25:31 -0500
Received: from web52506.mail.yahoo.com ([206.190.48.189]:39149 "HELO
	web52506.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751186AbXBUIZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:25:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=2lwWjskv8WjXOSafOtUmOBmArOkR5Cj35z9g/xHKgqLLQ1Gb0mBLj6EwnVIXkeXEWL+wi7g25iClwVMAU2dPVxzzIAo6zV12mpQM4ChT+Wab40muwmsNXNvWH+XvthEMpn0L52zOJi6n/opetXaxYEoiiAeePBm09R9B9egc34k=;
X-YMail-OSG: JQ9tmf8VM1k1CkkmtECVXvA4bwMqmyLHvDRJe0_FlhMcoGCz_L06IhzHnVgh8lrlxeh0V8wuuKjWHpogLhNy2IRVIdT1fZO78A6M_39O45kmOxPSDtFkplKqvsGVRJM160j1rMS_8Mh1t0w-
Date: Wed, 21 Feb 2007 00:25:29 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Need a little help with Software Raid 1
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <653453.23273.qm@web52506.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a partition that used to be part of a software
raid 1 array. It is now loaded as /dev/sda3 but I'd
like to mirror it to /dev/sdb3 without losing the data
on the drive. I'm a little nervous about how to set it
up as I don't want to wipe out the data.

How do I do this? Using FC6 and up 2 date software.

Thanks in advance.



 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
