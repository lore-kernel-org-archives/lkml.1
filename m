Return-Path: <linux-kernel-owner+w=401wt.eu-S934722AbXGLOTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722AbXGLOTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932741AbXGLOS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:18:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:18715 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbXGLOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KpN6djnjXNzuzdM4P9Q0qxNtRUg5o6O9MyQoD/PSz/WmnpcqSB+FsAV7qdYTqQQeYCn983DtyRTVYKH+Be8lg5pP5LFVTu09roPp1Z6rFJ1imE9UQ82i8GEQo0FglLkWzdpEeRNt71spMa5W+B8Ud8GHQmyQO59sfNXzBbdd0wM=
Message-ID: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com>
Date: Thu, 12 Jul 2007 10:18:55 -0400
From: "Mark Shelby" <mshelby1@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel autoconfig option?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have used Linux for about 9+ years. I have built several kernels.
The install process has gotten quite a bit better. The config menus are great!

I just downloaded and am setting up the 2.6.22 kernel.

I joined this list to ask a specific question:

Would it be possible to design a program to scan your existing system
hardware and pre-select your onboard hardware options within the
kernel config menus?

I am building this particular kernel on a laptop and am not likely to
be adding new hardware anytime soon! The only flaw I can find is in
add-on peripherals. I guess you'd want some way for the kernel to
anticipate & build in "useability" for common hardware plugins.

Am I just crazy, or wouldn't this idea mke a lot of sense? Wouldn't it
pretty much make the kernel "idiot proof" when installing from source?
