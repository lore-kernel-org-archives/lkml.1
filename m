Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbZG2Fup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbZG2Fup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 01:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZG2Fuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 01:50:44 -0400
Received: from mail-yx0-f190.google.com ([209.85.210.190]:44860 "EHLO
	mail-yx0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZG2Fuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 01:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=NnEFnN/eDHNSF5HsmxTRZemG8xk0ToQtYycLDsr7uveqLWvkcczNtcwPE3iBzUDhEn
         g+HfPHYJcCDEnbRz4L0OY2Wy2M4jedxgN5SCHbIwr6BZpPqEYHt5np/SEKVW/unMFh8I
         m5IdtbnefLcGNxSjCnPdFyTL11DY1OMhFYRK8=
MIME-Version: 1.0
Date: Wed, 29 Jul 2009 11:20:44 +0530
Message-ID: <241b8f7b0907282250k56807b83vba95ee9944d14edb@mail.gmail.com>
Subject: CTRL-C functionality.
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

  where  exactly can I check for the above signal is caught properly
or not.  How to enable ?

Because when I do ctrl-c my linux application is not terminating, I
want that signal to be cought.

It is the customized linux for the STB, soon box starts running
ctrl-C should teminate application.

have any Idea, where I need to look-in.

Thanks
Prabhu
