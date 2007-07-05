Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXGEAA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXGEAA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbXGEAAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:00:49 -0400
Received: from web54504.mail.re2.yahoo.com ([206.190.49.154]:28948 "HELO
	web54504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757219AbXGEAAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:00:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RoKI0Xiwh/UxbhtFUAKLwsC2oqx4i3u0rYcW+JrcrN9sVUJek5E0S8ABwMm41bUd/kMzLZXSiT4yRmtgjh5g+yvkFAKwprkGkrfomHIWwAb4wmdUGEaNGUkEI3EiopBDHp0z22a6O8cMMBSYSVHDIkY4SeG245bwcpd0mBEDGdM=;
X-YMail-OSG: iQatbLwVM1mBWoczhWcFhIeDuHu4UMdvvd7lk6UgZ7xdsg9Qu47vWjSbC8JGtyPU4A--
Date: Thu, 5 Jul 2007 09:00:47 +0900 (KST)
From: yong Jung <yong_jk@yahoo.com>
Subject: "libata ignore_hpa=1" doesn't wok on SATA ?
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Message-ID: <932011.56083.qm@web54504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
.
I would like to see the whole disk area and erase the
hpa area in my desktop.
At first I tried "setmax.c" program but it didn't work
on SATA at least.
So I upgraeded it to FC7 and added "libata
ignore_hpa=1" option on boot command and
/etc/modprobe.conf. 
This option was accepted but still the kernel couldn't
see the whole disk area even after reboot.
I am using FC7, kernel-2.6.21 and 250 SATA disk.
Could you please give me some more tips ?
.
Warm regards,
Nobel



      ________________________________________________________ 
180도 달라진 야후! 메일 - 여러 개의 메시지를 동시에 확인? 새로운 야후! 메일의 탭으로 가능해집니다.
http://kr.content.mail.yahoo.com/cgland
