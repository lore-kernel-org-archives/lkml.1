Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbZD2Bi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbZD2Bi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZD2Bir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:38:47 -0400
Received: from web32405.mail.mud.yahoo.com ([68.142.207.198]:25028 "HELO
	web32405.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755990AbZD2Bir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:38:47 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 21:38:46 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=xdlXDxYuGMlVO22YPhj8aX6fdo1rQmFuZCjnV0z1WzOKT+Bj4k+QoA0wWNbml6xTCBgbXqifN7/ggoXsbvoJO+JAiLllccf4V93tOlWLwXdwKX3d3RJdymIRQ7y0ybBdZocxDESb9hmL4/O4mM/KWEnCI3nKP9hSvCtvcWHRdFk=;
Message-ID: <254340.43645.qm@web32405.mail.mud.yahoo.com>
X-YMail-OSG: YnG7stAVM1k.mmUfQXcMsnRl3vpdHyMzOWQ0RZyJue8kmFEuByqR.aul.lIDGjZDEp22kv4KbjQDJZdJAAFHAsXadoh9XptnlV.KGzTyED78CkEVeqBny63V3lNkcK_orQZM7u_TlQSNSY9Ng6nv1xHSg_Om2Y4U65tam8BY4NCAROHuvRB_LW5VrMgSSUCh3x1ypfqHheTTG7b3yTbEhKL980Soh4SSzE7AW5SLY_gFzeUC_v2t2aLW2Lp3XSzVaHxEGD7Kun5U_59aWIUByu3I.s6k2MG2pqTZmYSN9N2368FsqxHy
X-Mailer: YahooMailClassic/5.2.19 YahooMailWebService/0.7.289.1
Date: Tue, 28 Apr 2009 18:32:07 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Subject: netlink NETLINK_KOBJECT_UEVENT older 2.6 kernels
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I see that we can use NETLINK_KOBJECT_UEVENT to send kernel messages to user space. This is available in most of the latest 2.6 kernels. But if I pick older kernels like 2.6.9 and NETLINK_KOBJECT_UEVENT is not available.

Is there anything equivalent to NETLINK_KOBJECT_UEVENT for the driver to send messages to user space in older 2.6 kernels?

Thanks for your help in advance.

With regards,
  Anil


      
