Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXFNHaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXFNHaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXFNHaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:30:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:6617 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXFNHaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:30:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XYdZn0qRfFj0lHMe4S/duOw11MWua22oVuJ9tijd8k3c7yPHf1c9HapNMgd/o0ToSk/vh8f/VZv/rhkU1IeO2h877vZtHvKRlQA9TgT4ijjJbHkXQajR50+FGISci3WIhYonEA89kTzgsVYU/Ga9FOFHKe9f480e1R+zqpjZFf4=
Message-ID: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Date: Thu, 14 Jun 2007 16:30:02 +0900
From: "Kentaro Takeda" <k.takeda26@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 0/9] TOMOYO Linux security module.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are TOMOYO Linux 2.0.
TOMOYO Linux 2.0 is implemented as a LSM module.

If you want to use older kernel, please download from
http://osdn.dl.sourceforge.jp/tomoyo/25693/tomoyo-lsm-2.0-20070605.tar.gz
