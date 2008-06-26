Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbYFZMsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbYFZMsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbYFZMcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:32:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:1433 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778AbYFZMcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=fBD3bupBWw6zZkJev2H+BXFl9R6iedvDDPmsd1doo2wBmbRHWWyDDR/a7/oENiw1U0
         llEtFyda0sdzZOHnoe1JfJj/XkuDTE4sOFniuBPjT9cDYKQGcCkuRMFlZQZRktEEadN5
         nIOmJHNQ7LmeMnxjE80NtPZ1jIBv2YR0emPZs=
Message-ID: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
Date: Thu, 26 Jun 2008 14:32:19 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Dave Chinner" <david@fromorbit.com>
Subject: [XFS] kernel panic on halt (2.6.26-rc7)
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       "Eric Sandeen" <sandeen@sandeen.net>, "Matthew Wilcox" <matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph, Dave,

a similar problem came out the with 2.6.26, than the was in post early
with 2.6.25[1][2]

http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00808.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00809.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00810.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00811.jpg

the git head is on 2.6.26-rc7,
was an any kind of bigger load however here, only desktop usage

the compiler is GCC-4.3.1 gcc (Debian 4.3.1-2) 4.3.1
pc: i386 (Pentium 4 HT Northwood, with enabled HT )

fs usage: 88%


--
[1] http://archives.free.net.ph/thread/20080616.100122.14303e7a.en.html
[2] http://students.zipernowsky.hu/~oliverp/upload/xfs_error/
-- 
Thanks,
Oliver
