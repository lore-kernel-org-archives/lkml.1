Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbZL1PN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbZL1PN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZL1PN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:13:26 -0500
Received: from zfrontend2.aha.ru ([195.2.83.148]:35385 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751414AbZL1PNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:13:25 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: kernel problem 2.6.33-rc2
To: anisse@astier.eu, lenb@kernel.org, randy.dunlap@ORACLE.COM,
       linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 28 Dec 2009 11:13:18 -0400
Message-ID: <web-124852048@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


   hello
  
  all the patches don't work. During booting happens the 
same as reported before.
  With 2.6.33-rc1 my server runs nice: 
http://guyane.dyn-o-saur.com/info.php


  
  For transparency, here are: two folders 2.6.33-rc2-git01 
and 02, including the patched subroutines and the patches 
itself what you sent me (however the patchs didnt work 
properly, in dell-wmi and hp-wmi occured errors of 1 hunk 
, so that I ended patching it manually, pls verify the 
subroutines if i patched it right); and the resulting 
kernel packages (including everything: patched source, 
kernel, modules -- please download them only if really 
necessary):
  
    ftp://guyane.dyn-o-saur.com




  I can try still any 2.6.33-rc1-gitX git if you think 
this is senseful. Also, you can send me next patches BUT 
IN THE NORMAL FORMAT OF KERNEL git.bz2 PATCHES (give them 
any -git number) inclusive the Makefile patch, so that I 
don't need patching manually which can result in next 
errors.
  


  W.Landgraf
---
Professional hosting for everyone - http://www.host.ru
