Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZEYKjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZEYKjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZEYKjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:39:31 -0400
Received: from web32407.mail.mud.yahoo.com ([68.142.207.200]:20651 "HELO
	web32407.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753347AbZEYKja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:39:30 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 06:39:30 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=qxnX9FVMLolsewX0VORpcUZNFz4Zd+3XYDoUrEIp/EIofxuJL3qpD2G842woPj08WFvU15GB1TArWGxZ40vE/LArKk4ybvoy1aNox3HEgGgI9Tg4PJMAPtoh16NVURWn5ZMNrvbWQcD7W9WvJirXK5uBSfy+cKVOGY8xb3Lglbw=;
Message-ID: <976507.1482.qm@web32407.mail.mud.yahoo.com>
X-YMail-OSG: 7pgg3OgVM1mGomfCWWNxGnMPH6dcuOnXUpehDr9vtibcfR6.sXttrj8XrD8NKXFcoBfjEfvjM1bjauB_D16WxfT1GKHL61utPL.PTD0qeOQmNv3N0OtDQwdfLiDO34OGVnOWMrkuWeqDuL4_to0sGhSF0gRU5XTByjMMNyKXQevxyOKi_Uxx3GIVDrKGgr5zy3QW3xKLHSq.Gat1WdkOFojR0Z9ABpGrYa_8B3eD.dOISHs97iBlscbSMpaqThCbBwbu8bWQVBUAPCK6bsahnGH2NNty8qBazrL6bVivsNytl2YG446Y
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
Date: Mon, 25 May 2009 03:32:50 -0700 (PDT)
From: Adrian Sandor <aditsu@yahoo.com>
Subject: Can't boot with smp
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, I'm having some problems with a computer - it restarts automatically when trying to boot.
It only boots successfully if I add the nosmp option to the kernel.
How can I find out what is happening (and fix it)?

CPU is "Intel(R) Core(TM)2 Duo CPU     E7300  @ 2.66GHz"
kernel is 2.6.28 (gentoo distro, 2.6.28-gentoo-r5)
I can provide the kernel config if desired.

Please CC me in replies.

Thanks
Adrian


      
