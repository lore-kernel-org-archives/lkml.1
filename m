Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZA1LNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZA1LNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZA1LNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:13:11 -0500
Received: from web25805.mail.ukl.yahoo.com ([217.12.10.190]:41553 "HELO
	web25805.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750995AbZA1LNK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:13:10 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2009 06:13:10 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mb9j3A0Xb870obeqD8+qnzaW703zJwfy3ef6RCLZZOkFn24E6w87ZdMMyAbv5pz9GMS3MKysMxB91fMGPlaWYf5Pz5YdqTxlXCmupAiXXBQYXKzenBxH0JIPQs2P3uL59TISHUr3/VpoUcM1OBbysrAJ5WygDChr6exkzGwUy5c=;
X-YMail-OSG: G4mKho0VM1k59sdJSsp2WIb.l0SsDvPrHO12Te4W7ru80sd9mPLiXYkHddt7Fugvv0dp5rDjI0ob4u_iXerMEmyKW9EHPPMNjqMZhbdt.To1gu96zjXRKR3CZwjhAhsAidw6EAnRAcRwRmvsFypG7OoaFtjceHfrvP3ZLP875YVKTymLi0AOxGnc6fcHpY.r9exFK7AT.yuzg5GX2HcBif1U7NLuE0VToPRh
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
Date: Wed, 28 Jan 2009 11:06:25 +0000 (GMT)
From: A B <spinflipper4@yahoo.co.uk>
Subject: Fat64 / exFat fs and Linux
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <5272.25444.qm@web25805.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since Microsoft has now released their fat64 / exfat fs also for their 'stable' product line [1] and it seems to be the future choice for large capacity removable flash media, it seems likely that Linux users will start seeing this fs on USB sticks, portable drives and SDXC flash cards in the near future. The status at this time seems to be that there is no driver available and the specifications are not published either. Is someone working on a driver at the moment or are there any plans? Somehow it does not seem entirely unlikely that the past nightmare of linux-unreadable NTFS disks and media prior to the present NTFS driver will repeat itself with exFAT.

Max

[1] http://support.microsoft.com/?kbid=955704



      
