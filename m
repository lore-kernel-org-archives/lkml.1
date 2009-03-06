Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZCFLnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZCFLnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZCFLnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:43:06 -0500
Received: from smtp12.mail.tnz.yahoo.co.jp ([203.216.226.140]:34800 "HELO
	smtp12.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751549AbZCFLnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:43:05 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2009 06:43:05 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MIMEOLE;
  b=bqgcQWBuIzyt8gcRPEL0ooRTLz8s2V6ZMCnVixhIeKibICaQSPdm4OMTSfC52/Ol5k5arX55PdI0/p/OeiE4kGdOWT+kvi00+8yVnHZOoQ8E22z8mNm9d0qfiw4qrQzM  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <0655A11E08814D889E40E4BB3B61C0AD@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: <linux-kernel@vger.kernel.org>
Cc: "Norman Diamond" <n0diamond@yahoo.co.jp>
Subject: How to find out if /dev/fd0 represents an existing floppy drive?
Date: Fri, 6 Mar 2009 20:36:11 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long long ago in a galaxy far far away a program could find out if /dev/fd0 
really represented an existing floppy drive or not.

#define FD_DRIVE_PRESENT 8

Now that bit is unused.

In this millennium is there some way for a program to find out if /dev/fd0 
really represents an existing floppy drive?
--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
