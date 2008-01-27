Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYA0Qcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYA0Qcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 11:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYA0Qcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 11:32:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:30801 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYA0Qcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 11:32:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=drC0CNQNIIylP/d6ezK83hznDWnuHQnVc6STBH3C8iCXTny6eJgzIPl+h5X/dOgDnBpnYPa+nB+Dx0+Id5muClw9nNoTYmgp9ofRftdg+s/+JYXtOS5jWo8ur1okVhwA+24w8EMN8zQus7XBMamG+t806br+dmGvg02o4n0IGTA=
Message-ID: <653402b90801270832v7ca7a12au11ce309d341a24b5@mail.gmail.com>
Date: Sun, 27 Jan 2008 17:32:38 +0100
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: scsi_wait_scan module
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some people mailed about the scsi_wait_scan module being built every
time (without any way to disable it). Why any patch has been applied
to change this behavior?

As I understand the documentation, the module is only useful "if you
have built SCSI as modules" and "Asynchronous SCSI scanning" is
enabled.

Should not be -at least- a way to disable it?

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
