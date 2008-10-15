Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYJOJEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYJOJEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:04:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJOJDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:03:53 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:60642 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYJOJDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ctjW0GOoab33xVDFdFFWuWMiCqtNjjTzjZ+rdsJNXMm8AEY5yKMdgqMmdpVJ2ghTJh
         +FycoBOWax3hPTZXATGZ1IZtgsdKP3j4DEgCR4fs0Iw6XrHfXrwPkrNfI18xTncbkgPg
         c4HQyY5SPZyoHXr/7BXKj3hfSBjELVRbIgioI=
Message-ID: <2ea1731b0810150203t10567a74xb10e214396073771@mail.gmail.com>
Date: Wed, 15 Oct 2008 11:03:50 +0200
From: "Marco Stornelli" <marco.stornelli@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] PRAMFS with XIP support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I forward ported the PRAMFS for 2.6.27 kernel. In addition I added the
XIP support for this kind of filesystem. I've got even some benchmark
results made with bonnie++. You can download the patches from
http://sourceforge.net/tracker/?atid=595818&group_id=91077&func=browse.
I'm not posting here because the patches are very big ~2800 lines of
code. Any comments are welcome.

Regards,

Marco Stornelli
