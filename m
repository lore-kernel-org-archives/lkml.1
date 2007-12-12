Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbXLLQbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbXLLQbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbXLLQbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:31:36 -0500
Received: from web52506.mail.re2.yahoo.com ([206.190.48.189]:25699 "HELO
	web52506.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751291AbXLLQbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:31:35 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 11:31:35 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=wEgNzfkurw9XypiSRfj7d3D61BX5WkAMX9o1DuZ/zorK0BE/jWoqBQ+7Pmu2n1oqoWCrXzP8IyLf/96Z/vrktGpfj8PIEWvFIY6BXR68oo9AV9SjDcxkMqulPF2/eN5+fRrUPUJeWw/N6EgNCkI5pxYGkCpZIyk2nwTm9xxZZKQ=;
X-YMail-OSG: Vz2fADUVM1lhIvTV8uXi0yIKs6O4ukFewtxKyZoZEaba4v8zhpOFKsjtrGKs_haxKQ--
Date: Wed, 12 Dec 2007 08:24:53 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Kernel friendly chipsets - video drivers - nVidia vs. AMD 690G
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <13593.8007.qm@web52506.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about chipset compatibility for
video.

I have an Asus motherboard with integrated graphics
using the nVidia chipset and a large monitor
(1680x1050) and eventually got it to work. 

I have a new Asus motherboard that I'm thinking about
using as a replacement that uses the new AMD 690G
chipset. I'm thinking of using it in the workstation
and using the nVidia board on a colo machine.

My question - how friendly is the video drivers in
Linux with the AMD690G chipset? Is it going to work in
1680x1050 mode easily or should I stick with nVidia?


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
