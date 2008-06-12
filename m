Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYFLQMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYFLQMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYFLQMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:12:43 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:23140 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYFLQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:12:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=scm6bY3r+L+ws+V2EEU36TVmzwdpjyrIlNaD+X8AiJZgCQyB3vpokB7nCiNr66QPv8
         gRnUSWvO4VZMFSbnHKoGgpXkmrlWalhs4A7XOjCaIAap67QXyncF8JPSWlqoXniKoeb4
         /uOMb+sgatWJp6NghvjU2CYiAQ63BVhlBTtaY=
Message-ID: <b9df5fa10806120912x51e8be39xe1c61ce8cc9c54ca@mail.gmail.com>
Date: Thu, 12 Jun 2008 22:12:40 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: WARNING: ignoring return value on add_device.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, in kernel version 2.6.25.6 , 2.6.26-rc4 with defconfig shows following:
fs/partitions/check.c: In function `add_partition':
fs/partitions/check.c:381: warning: ignoring return value of
`device_add', declared with attribute warn_unused_result

Any patch ?
Thanks.
