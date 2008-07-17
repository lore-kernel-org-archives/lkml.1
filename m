Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbYGQTqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbYGQTqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbYGQTqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:46:23 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:27802 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760048AbYGQTqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gxQNpB47AqWQAmDQX4od4Jt+qJ5X3Vo7xNXXfyE431oU6iY/4YU3XlpBTuAtzXIgum
         4RW6onJ7uc85p/vWQiVaHSrSXOnDsBgw/ugx+/7NkNVz8HC6TxpU792wVlqP1BOtLxk2
         B9jLS/LWPtVT1rGsYoq0EZAGLmmyHxW12f4q0=
Message-ID: <f188924b0807171246v1ae9193bp90b2ce682f96738a@mail.gmail.com>
Date: Thu, 17 Jul 2008 21:46:20 +0200
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Add UDF 2.60 support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently released kernel 2.6.26 came with UDF 2.50 support.
* http://en.wikipedia.org/wiki/Universal_Disk_Format

We should get support for UDF 2.60. Please, add support for it!

The Universal Disk Format (UDF) is a format specification of a file
system for storing files on optical media. It is an implementation of
the ISO/IEC 13346 standard.

Revision 2.60 (March 1, 2005).

Considering that 2.60 been out since 3 years ago, it is rather bad
that we still don't support it.

Also the 2.50 support we have is read-only. We need full read/write support.
