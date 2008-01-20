Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYATHIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYATHIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 02:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYATHIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 02:08:45 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:3261 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYATHIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 02:08:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FcDg6RUDjFf928bUztWbsSui+j6/ODxg9gdpZdoK+P2ekmAEcpLxWOhrJgYLqr+64Ybw349lFsDh+Ydrjy2Qoj/jEd0CwnvII5+rZZrjAkye7CDvGqSnNFpBg78dgWFxi/MmUjZeGng/SlUkprAN/3awUmLuxAWb3Np49kkSaUE=
Message-ID: <d0383f90801192308h7888079cubb47daf6ec465d0f@mail.gmail.com>
Date: Sun, 20 Jan 2008 09:08:43 +0200
From: "Ian Brown" <ianbrn@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de, kpm@linux-foundation.org
Subject: sysfs network namespace support - was this patch set forgotten ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I saw some posts (from about a month ago) about network namespace
support patches; I wonder: what
is the status of this patch set ? was it somehow forgotten ?
(I don't see it in v2.6.24-rc8 mm tree).

see:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-12/msg07720.html
http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-12/msg00096.html

Regards,
Ian
