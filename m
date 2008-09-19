Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYISOaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYISOaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYISOao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:30:44 -0400
Received: from web52908.mail.re2.yahoo.com ([206.190.49.18]:36664 "HELO
	web52908.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752660AbYISOan convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:30:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=E3hx2ZkEeAxVhwbE0W6iEvEZ5aK5FhyyN7w8ypfp5MFKeKyAV9VQsqfSqqEsdZdH97aDrEXx5oRdzBS4jS6jrIvdiUjGf3H2Hnp65qOw3J/rMMsY1GWDgap0ioEbSZrOSOBC4WLPtm0MHIM5UedwKVz8QSVrPxTu01cZxtpXDAo=;
X-YMail-OSG: XPJV.nUVM1nbr.1kANpoLpA1YvAuUNtu24Il36ZxjjH09TQcvEtirccEU3zQ5aw5_GqLVLL6zueUHvETXKHOlqr7INmJhRZlZULm7YLKmGu4z6i4ZtZFcHYBGZnLN0P8uS4RmXNzbk_RqoOWiQRcJDP_00JVfw--
X-Mailer: YahooMailWebService/0.7.218.2
Date: Fri, 19 Sep 2008 07:30:42 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: rankincj@yahoo.com
Subject: Thinkpad T60p does not recover from Suspend when docked.
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <631160.40261.qm@web52908.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Thinkpad T60p with an "advanced dock" that contains an extra SATA drive, and I have noticed that when the extra drive is in the docking station then the laptop no longer recovers from Suspend. Remove the drive from the docking station and the laptop suspends and resumes OK again.

My user-space environment is Fedora 9, which automatically mounts the docking station's drive under /media when I login. However, it doesn't make any difference if I unmount this drive before suspending - the laptop fails to recover regardless.

I am running a 2.6.25.17-SMP kernel (for graphics card reasons), and can provide ACPI table dumps if required. Can anyone suggest anything to try, please?

Thanks,
Chris



      
