Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYJLI2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYJLI2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYJLI17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:27:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:44848 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYJLI16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=HnR6/dAHsVgj7O6xuKc2VP4PSCGk8k8GOxIlm/EHxgBQcx3ojSB0GtkIwcFJtBFkl1
         HQNATJqinZeXJpn2OJuZJCQdrKt9pPyb27Y8D5zxDTIfQoAVasSrGDHu5o6DV2JqJPmF
         qjPI4DNBtbBnEdkivo3I5DJ6Je8h0+2TXR57U=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: oops while booting with recent git kernel
Date: Sun, 12 Oct 2008 12:27:08 +0200
User-Agent: PLD Linux KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810121227.09114.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not sure if it's worth to report this before all initial merges happen but 
here it is anyway.

git kernel with latest commit:
commit fd048088306656824958e7783ffcee27e241b361
Date:   Sat Oct 11 13:23:48 2008 -0700

booted on thinkpad z60m results with such oops:
http://carme.pld-linux.org/~arekm/img_2325_small.png

Config used:
http://carme.pld-linux.org/~arekm/img_2325_small.config

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
