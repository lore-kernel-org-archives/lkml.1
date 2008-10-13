Return-Path: <linux-kernel-owner+w=401wt.eu-S1764963AbYJMKUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764963AbYJMKUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYJMKUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:20:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:7152 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbYJMKUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=b1CyF68OMqb3KWHLRTneXDXVr6FYkTYtGoCsHkR/ym50NPag8ltWY4puoOsMDABH0d
         zMnBre8cgEeNVBjbXp652+ztPbdHiu3ToXmha0JaEBvy4saCaRYJBLAglxRa7Xf1OBkS
         482hlV64xCIQ1/d7QbwLi3dQgW0MD85BMqliQ=
Message-ID: <31cff80d0810130320w29e0cb77yc728701fbaa753ea@mail.gmail.com>
Date: Mon, 13 Oct 2008 15:50:07 +0530
From: "ranjith kumar" <ranjithproxy@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: about virtual memory
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I am working on 32bit x86 processor and my operating sysytem is linux.
I know that cat /proc/meminfo will tell size of RAM.

1) But how to know the total size of virtual memory my system has?
2) How to know size of pageframe?
3) How to know which page frames are free/allocated??
Thanks in advane.

note: Please CC to my mail.
