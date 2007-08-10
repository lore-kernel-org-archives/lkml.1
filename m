Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbXHJGu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbXHJGu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbXHJGuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:50:21 -0400
Received: from web15709.mail.cnb.yahoo.com ([202.165.102.76]:21415 "HELO
	web15709.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752299AbXHJGuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:50:20 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 02:50:18 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mpCgkV91mDi+n1auL+zpE8UWFx9hCk3jdz/GGBjGRNA1ixtYYbAa36M6C8yegCKbDwIQmL87GNsdaJMV9FAiJywMceyDg6v+cLyN6zexrIuG2a3P8o6QRn5xqUNhZHgQjqz8z8llIsLaY9vIwzvhTJq20Z0yXNYx6Ti39QfEylQ=;
X-YMail-OSG: giJSulsVM1n.jCoK6OofyowiX0vY3dBh8BTb6fICp6qs2NkNNBbay9XQQ3TMYj9py5Njuhg8QHmJMcqqGAHIMPzUfw--
Date: Fri, 10 Aug 2007 14:42:55 +0800 (CST)
From: Gu Song <qemuser@yahoo.com.cn>
Subject: ISA NE[12]000 NIC not work since 2.6.21 on QEMU
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8bit
Message-ID: <876816.29120.qm@web15709.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.20.x kernel work well with QEMU ISA NE2000 NIC, 
 2.6.21.x-2.6.22.x can find that NIC, but not work 
by static ip nor dhcp. 
Test system is qemu-system-mipsel v0.9.0.


      ___________________________________________________________ 
ÇÀ×¢ÑÅ»¢Ãâ·ÑÓÊÏä3.5GÈÝÁ¿£¬20M¸½¼þ£¡ 
http://cn.mail.yahoo.com
