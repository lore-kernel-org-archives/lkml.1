Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbXLHAVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbXLHAVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXLHAUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:20:53 -0500
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:50820 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXLHAUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:20:53 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2007 19:20:52 EST
From: CIJOML <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org
Subject: HTC TyTN || (P4550) violates GPL?? Or maybe Qualcomm itself with MSM7200???
Date: Sat, 8 Dec 2007 01:15:05 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712080115.05608.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

it looks like there is running linux somewhere inside in the radio part of the 
firmware...

http://forum.xda-developers.com/archive/index.php/t-326419.html

$ strings kaiser_radio_0x301.nb |grep -i linux
 M6500C L4/Linux
 L4 Linux
 NICTNICTA::Pistachio - built on Jan 23 2007 18:10:22 by dpandian@l4linux15 
using gcc version 3.4.1
 start_linux_cmd
 vmlinux != NULL
 vmlinux
 vmlinux igms_name=ramdisk root=/dev/igms0
 start_linux

Can anybody else confirm this and contact those companies for source codes?

Thanks a lot!

Michal
