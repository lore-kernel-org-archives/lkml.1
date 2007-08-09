Return-Path: <linux-kernel-owner+w=401wt.eu-S939301AbXHIOLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939301AbXHIOLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938819AbXHIOLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:11:36 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:55087 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940393AbXHIOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tuJJTtm3bYIxxuQWnaH8H7mGJcNZihcpBR72Kr8dsTl5TCKcMPIuCqGWxLYEvHBpeso1q9Z3i+P1xK9adW3ZkUR/t0kYwauXtaWn8J0XMR9z51UbY6HV/FIt16cSB9SE7gjxqqg7vTivb5nyRqRJ1iZWOC1I4dnf+kzuSFYaOCE=
Message-ID: <4104961b0708090711j291974cbx933e1262ba1935f6@mail.gmail.com>
Date: Thu, 9 Aug 2007 22:11:33 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: What does 'if EMBEDDED' mean?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For example,

config SYSFS
        bool "sysfs file system support" if EMBEDDED
        default y

What does 'if EMBEDDED' mean?Can I choose n here?
I saw there is no corresponding option within `make menuconfig`, so I
am wondering what can I do if I wanna to disable this option, directly
change
"default y" to "default n" in the Kconfig file?

Thanks
Jason
