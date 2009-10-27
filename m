Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZJ0HvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZJ0HvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZJ0HvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:51:13 -0400
Received: from web94710.mail.in2.yahoo.com ([203.104.17.170]:30390 "HELO
	web94710.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756533AbZJ0HvM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:51:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2009 03:51:11 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zVsUAtXw+TGXWpztTq26U8lr0ZonMTwxX8KPpoTgtsWXlIJZnNmFs6bOqUiryrCVvTXQggxR8gJBGx+DNJHJfQ3jLrLe8PcgFjXAIziW515oHojgxI5uUi1STccsbUQ1/MxDKP5GTntVVbavflORC8DdiAGW1wjcu2FMjPjtnxQ=;
Message-ID: <256042.70547.qm@web94710.mail.in2.yahoo.com>
X-YMail-OSG: Y7Ay_M0VM1mehpVQ2g0lk87zl67RKIXfd_9DspyReHvzycdvClFALKVRP4.y4UiqhAEC.YomKWcqA4j5t5qwFOyy_y3btmhfl67QPUEkVWz3ceflSoljjKcVTOdl6Y8DsPUEK3k5docEHb20b3VeqkRCClmiXzEDHEzopsQ5wAorHDlh70h1u6BxEhfSBWJddAtjM1b233hZgsPU9uz..AulJqyllV24FNp0bMpuZnMsd1JP6BJS0BZ_doGlX8_wV6JNCNA-
X-Mailer: YahooMailClassic/8.0.7 YahooMailWebService/0.7.361.3
Date: Tue, 27 Oct 2009 13:14:34 +0530 (IST)
From: J K Rai <jk.anurag@yahoo.com>
Subject: Instantaneous snapshot of CPU schedule
To: lkml <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Is there any utility using which we can take current (instantaneous) snapshot of process schedule on the linux based system from user land. Like use a system call or command to know what is running on each of the cpus 0..n-1 (assuming n cpus in the system). Output could be like tuple (pid, cpu_no).

If such utility does not exist then kindly throw some light / ideas so that it could be implemented.

Regards,
Jitendra


      Add whatever you love to the Yahoo! India homepage. Try now! http://in.yahoo.com/trynew
