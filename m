Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYFILxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYFILxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760043AbYFILxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:53:14 -0400
Received: from web26005.mail.ukl.yahoo.com ([217.12.10.216]:25333 "HELO
	web26005.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759970AbYFILxM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:53:12 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 07:53:12 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=EMKwwkt1KJkq9vX/3NumZSYTOCrD1i/SKF99njlJmuWPdKu/2hRsXBHl72AEWcwJxEiBUW8NQj7iwYxIEk698PiDKmNe26w4g2CIghc292EWNBDbtbOxYNZCoJa8Vm7anefPTpcnc6XTRUYLaII94a/RnrkWdRT2ci0KiMyd/eA=;
X-Mailer: YahooMailWebService/0.7.199
Date: Mon, 9 Jun 2008 11:46:30 +0000 (GMT)
From: Will C <willjcroz@yahoo.co.uk>
Subject: Re: Better support for Delkin cardbus CF adapters -- IDE layer
To: linux-kernel@vger.kernel.org
Cc: yorgasor@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <300869.94850.qm@web26005.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( please CC me also )

I have the same Delkin 32-bit UDMA Cardbus to CF adpater also, (vid: 0x1145 pid: 0xf103)

The windows driver for it, supplied by Delkin is written by Workbit, it seems they make the bridge chip inside:

http://www.workbit.co.jp/products/utata.html


Google translation:

http://66.102.9.104/translate_c?hl=en&sl=ja&u=http://www.workbit.co.jp/products/utata.html


The contact form does not translate correctly and so it seems someone fluent in Japanese would be the best bet to approach Workbit for documentation/specification.

I have a brand new spare card here (with a Delkin 2GB 305x speed CF card in it) and am willing to send it to a kernel developer interested in working on a driver for it (Mark Lord?). Alternatively if anyone wants me to dump registers under Windows, test drivers etc I am prepared to put in the time to help in these ways. FWIW there seems to be a MacOSX driver available as well as a windows one according to the site.

This card is currently the fastest CF reader available (except for clumsy FireWire readers) and offers an ideal  way of adding a SSD to a laptop - since it is very fast (40MB/s) and could enable a laptop to run its OS from the Cardbus slot, leaving the the main HDD to be spun up whenever large amounts of data need to be accessed. There seems to be a lot 'DIY SSD' enthusiasts out there (like me) along with digital photographers who would make use of a driver for this card under Linux.

Please let me know if anyone is interested and I can help in any way.

Cheers,

Will Crozier



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html
